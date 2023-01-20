public class Sentence_stub extends SharedObject implements Sentence_itf, java.io.Serializable {
	Sentence_stub(Object o, int id) {
		super(o, id);
	}
	public void write(java.lang.String p0) {
		Sentence o = (Sentence) obj;
		o.write(p0);
	}
	public java.lang.String read() {
		Sentence o = (Sentence) obj;
		return o.read();
	}
}
