
public class IntContainer implements java.io.Serializable {
	private int value;
	public IntContainer() {
		this.value = 0;
	}
	public int get() {
		// TODO Auto-generated method stub
//		System.out.println("value read : " + this.value);
		return this.value;
	}

	public void put(int newValue) {
		// TODO Auto-generated method stub
//		System.out.println("value wrote : " + newValue + " previous : " + this.value);
		this.value = newValue;
	}
}
