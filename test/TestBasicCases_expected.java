import java.util.*;
public class TestBasicCases {
protected int f;
protected int g;

public int[] a = {1,2,3};
public int[] b = new int[0];
public int[] c = Test.<Object, Object>m(a, b);
public int[] d = new int [2];
public int[] e = {1,2,3};

public int i;
public int j;

   static <T1, T2> int[] m(T1 t1, T2 t2) {
      return new int[0];
   }
}

class MyType {}