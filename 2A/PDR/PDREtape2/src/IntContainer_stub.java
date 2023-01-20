public class IntContainer_stub extends SharedObject implements IntContainer_itf, java.io.Serializable {
	IntContainer_stub(Object o, int id) {
		super(o, id);
	}
	public int get() {
		IntContainer o = (IntContainer) obj;
		return o.get();
	}
	public void put(int p0) {
		IntContainer o = (IntContainer) obj;
		o.put(p0);
	}
}
