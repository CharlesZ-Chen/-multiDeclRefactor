/* Currently multiDeclRefactor would failed to refactor below code,
* See issue: https://github.com/CharlesZ-Chen/multiDeclRefactor/issues/2
* output would like this:
* <code>
* class Issue2 {
*  String Object c = new C() {  a, b;
*   Object d; String e,f;
* }
*
* interface C {}
* </code>
*/

class Issue2 {
    Object c = new C() { String a, b; };    
    Object d; String e,f;
}

interface C {}
