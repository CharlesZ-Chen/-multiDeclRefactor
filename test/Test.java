import java.util.*;
public class Test {
protected int f, g;

public int[] a = {1,2,3}, // line comment with ;
 /* multi line comment
 * asd
 (*/
 b = new int[0],
 /*insance comment*/ c = Test.<Object, Object>m(a, b),
 d = new int [2], // comment
 /*insance comment*/
 e = {1,2,3};

public int i, j;

   static <T1, T2> int[] m(T1 t1, T2 t2) {
      return new int[0];
   }
}

class MyType {}