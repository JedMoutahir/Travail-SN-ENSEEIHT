public class Compteur_stub extends SharedObject implements Compteur_itf, java.io.Serializable {
	Compteur_stub(Object o, int id) {
		super(o, id);
	}
	public void increment() {
		Compteur o = (Compteur) obj;
		o.increment();
	}
	public int read() {
		Compteur o = (Compteur) obj;
		return o.read();
	}
	public java.util.List getHistorique() {
		Compteur o = (Compteur) obj;
		return o.getHistorique();
	}
}
