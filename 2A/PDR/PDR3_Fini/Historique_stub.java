public class Historique_stub extends SharedObject implements Historique_itf, java.io.Serializable {
	Historique_stub(Object o, int id) {
		super(o, id);
	}
	public void add(java.lang.String p0) {
		Historique o = (Historique) obj;
		o.add(p0);
	}
	public java.util.List get() {
		Historique o = (Historique) obj;
		return o.get();
	}
}
