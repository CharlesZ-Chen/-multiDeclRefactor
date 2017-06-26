import sys, os
import shutil, tempfile
import json

def main():
    try:
        total_multi_decls = json.load(sys.stdin)
        refactor_decls(total_multi_decls)
    except ValueError:
        for line in sys.stdin:
            print line
        sys.exit(1)

def refactor_decls(total_multi_decls):
    file_based_multi_decls = collect_by_file(total_multi_decls)
    for refactor_file, multi_decls in file_based_multi_decls.iteritems():
        refactor_decls_in_single_file(refactor_file, multi_decls)

def refactor_decls_in_single_file(refactor_file, multi_decls):
    # print multi_decls
    backup = refactor_file + ".origin"
    shutil.copyfile(refactor_file, backup)
    origin_line_no = 1;
    with open(backup, 'r') as origin_file:
        with tempfile.NamedTemporaryFile(mode='w', suffix='.java') as out_file:
            ORIGIN_LINES = origin_file.readlines()
            refactor_list = produce_refactor_list(multi_decls, ORIGIN_LINES)

            # print refactor_list
            ## ASSUMPTION: refactors are sorted by start line (first element in a tuple element in the list)
            for (start_line, end_line, decl_type, decls) in refactor_list:
                while origin_line_no < start_line:
                    out_file.write(ORIGIN_LINES[origin_line_no - 1])
                    origin_line_no += 1;
                origin_line_no = end_line + 1

                ## write refactored decls
                decl_list = list()
                for decl in decls:
                    decl_list.append(decl_type + ' ' + decl + ';')

                for refactor_decl in decl_list:
                    out_file.write(refactor_decl + '\n')


            while origin_line_no <= len(ORIGIN_LINES):
                out_file.write(ORIGIN_LINES[origin_line_no - 1])
                origin_line_no += 1;

            out_file.flush()
            shutil.copyfile(out_file.name, refactor_file)

def produce_refactor_list(multi_decls, ORIGIN_LINES):
    refactor_list = list()
    for multi_decl in multi_decls:
        refactor = produce_refactor(multi_decl, ORIGIN_LINES)
        refactor_list.append(refactor)
    return refactor_list

def produce_refactor(multi_decl, ORIGIN_LINES):
    start_line_no = multi_decl['line']
    declared_type = multi_decl['declared_type']
    (end_line_no, multi_decl_str) = get_multi_decls_as_str(multi_decl, ORIGIN_LINES)

    decl_list = get_decl_list(multi_decl_str, declared_type)

    return (start_line_no, end_line_no, declared_type, decl_list)

def get_multi_decls_as_str(multi_decl, ORIGIN_LINES):
    """This function will remove comments in multiple declarations statement.
       The statement semi-comma will also be removed.
    """
    decl_str_list = list()
    cur_line_no = multi_decl['line']
    is_end_line = False
    has_unclosed_comment = False

    while not is_end_line:
        cur_line = ORIGIN_LINES[cur_line_no - 1]
        (processed_line, is_end_line, has_unclosed_comment) = process_line(cur_line, has_unclosed_comment)
        decl_str_list.append(processed_line)
        cur_line_no += 1

    reformat_multi_decls_str = " ".join("".join(decl_str_list).split());
    return (cur_line_no - 1, reformat_multi_decls_str)

def process_line(line, has_unclosed_comment):
    if has_unclosed_comment:
        i = 0
        while i < len(line):
            if line[i] == '*' and i < len(line) - 1:
                i += 1
            if line[i] == '/':
                return process_line(line[i + 1:], False)
            i += 1
        return ("", False, True) # empty line, not end line, has unclosed comment

    i = 0
    while i < len(line):
        # if meet a '/' then is must be '//' or '/*' for a well-grammered line
        if line[i] == '/' and i < len(line) - 1:
            cmt_start_idx = i;
            i += 1
            if line[i] == '/':
                ## this line is a single line comment
                return (line[:i - 1], False, False) #(remaining line, not end line, no unclosed comment)
            elif line[i] == '*':
                i += 1
                while i < len(line):
                    if line[i] == '*' and i < len(line) - 1:
                        i += 1
                        if line[i] == '/':
                            # recursive produce line: (line before cmt + line after cmt)
                            return process_line(line[:cmt_start_idx] + line[i + 1:], False) 
                    i += 1
                return (line[:cmt_start_idx], False, True)

        if line[i] == ';':
            return (line[:i], True, False)
        i += 1

    return (line, False, False)

def get_decl_list(decls_str, declared_type):
    """ public int[] a = {1,2,3}, b = new int[0], c = Test.<Object, Object>m(a, b), d = new int [2], e = {1,2,3}
    """
    """ given a decls string, split it to a list that each item is a single declaration without type.
    """
    #remove type first
    decls_str = decls_str.replace(declared_type, '').strip()
    decls_list = list()
    LEFT_SET = set(['(', '<', '{'])
    RIGHT_SET = set([')', '>', '}'])
    # indicate whether current iterating in a parameter decalration like "<x, x>" or "{x, x}" or "(x, x)"
    in_param_level = 0

    i = 0
    start_idx = i
    while i < len(decls_str):
        if decls_str[i] in LEFT_SET:
            in_param_level += 1
        elif decls_str[i] in RIGHT_SET:
            in_param_level -= 1
            assert in_param_level >= 0
        elif decls_str[i] == ',' and in_param_level == 0:
            decls_list.append(str(decls_str[start_idx:i]).strip())
            start_idx = i + 1
        i += 1

    if start_idx < len(decls_str):
        decls_list.append(str(decls_str[start_idx:]).strip())

    return decls_list


def collect_by_file(multi_decls):
    file_based_multi_decls = dict()

    for decl in multi_decls:
        file_path = decl['file']
        if not file_path in file_based_multi_decls:
            file_based_multi_decls[file_path] = list()
        decl.pop('file')
        file_based_multi_decls[file_path].append(decl)
    return file_based_multi_decls

if __name__ == '__main__':
    main()

