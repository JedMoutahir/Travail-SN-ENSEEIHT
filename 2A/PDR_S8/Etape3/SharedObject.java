
public class SharedObject implements SharedObject_itf {
	private int version;
	private Object content;
	
	public SharedObject(Object content, int version) {
		this.version = version;
		this.content = content;
	}

	@Override
	public Object read() {
		// TODO Auto-generated method stub
		return this.content;
	}

	@Override
	public int write(Object valeur) {
		// TODO Auto-generated method stub
		this.content = valeur;
		version++;
		return version;
	}

	@Override
	public int getVersion() {
		// TODO Auto-generated method stub
		return this.version;
	}
	
}
