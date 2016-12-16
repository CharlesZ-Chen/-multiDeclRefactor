import sys
import json

import multiDeclRefactor

### key: issue name in checkstyle,
### value: refactor method main entry
REFACTOR_DICT = {
    "HackedMultipleVariableDeclarations" : multiDeclRefactor.refactor_decls
}

def main():
    try:
        data = json.load(sys.stdin)

        for issue, refactor in REFACTOR_DICT.iteritems():
            refactor(data[issue])

    except ValueError:
        for line in sys.stdin:
            print line
        sys.exit(1)

if __name__ == '__main__':
    main()