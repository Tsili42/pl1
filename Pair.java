public class Pair<T> {

  private T a;
  private T b;

  public Pair(T a, T b) {
    this.a = a;
    this.b = b;
  }

  public T getA() {
    return a;
  }

  public void setA(T a) {
    this.a = a;
  }

  public T getB() {
    return b;
  }

  public void setB(T b) {
    this.b = b;
  }

  public boolean isEqual(Pair<T> t) {
    return ((this.a == t.a) && (this.b == t.b));
 }
}
