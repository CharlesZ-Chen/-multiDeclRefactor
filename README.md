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
