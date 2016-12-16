# multiDeclRefactor

Simple and a bit ugly tool for refactoring multiple declarations in Java:

e.g. Given a java file has multiple declarations:

```java
public class MultiDecl {
    private int a, b, c;

    public List<String> d = new ArrayList<>(),
                        e,
                        f;
}
```

it will refactor all multiple declarations in one statements to each declaration per statement:
```java
public class MultiDecl {
private int a;
private int b;
private int c;

public List<String> d = new ArrayList<>();
public List<String> e;
public List<String> f;
}
```

**Note** : this tool behave as a pre-processor for code analysis, so that the produced result is a bit unfriendly to human-readability:

1. it will remove all comments appeared inside a statement of multiple declarations

2. it will not keep the origin indentation of a refactor statement

## building
just run following script:
```bash
./fetch_dependency.sh
```
## usage

```bash
./run-refactor.sh a.java b.java ...
```

## dependency

This tool depends on a hacked version of [checkstyle](https://github.com/CharlesZ-Chen/checkstyle) in my git repo. (branch `multiDeclJson`)

The hacked version of `checkstyle` is the backend of this tool, i.e. it detects the multiple declarations in a source file and then propage the diagnostic result to this tool.

I currently still not have time to write test framework for this tool, but hopefully I will create one soon.

## developer notes

### Architecture

This tool is actually just a light-weight front-end that recieves diagnostic reports and then do refactors based on the reports, i.e. it doesn't has the ability of dectecting multi-declartions issues, instead, it needs a back-end reports issues and then it do refactors based on reports.

It uses `json` as the data format, and the diagnostic report format shown below:

```json
[
        {"file" : absolute_java_file_path,
         "line" : line_number,
         "declared_type" : type
        },
        {"file" : absolute_java_file_path,
         "line" : line_number,
         "declared_type" : type
        }
]
```

In above json format, "file" is the absolute java file path that contains one or more multi-declaration issues. "line" is the start line number of a multi-declaration issue. "declared_type" is the java type with modifiers for a multi-declarations.

I currently have a `controller_checkstyle.py` as the middleware between the `checkstyle` backend and `multiDeclRefactor` frontend.

Current architecture would make below future changes easy:

- provides a new frontend/backend: just make a frontend/backend that output follows the json protocal.

- extend the refactor to process a new kind of issue: make hacks on `checkstyle`, provides a `**check.xml` to do the issue check, and then add a new python front-end to do the refactor.
