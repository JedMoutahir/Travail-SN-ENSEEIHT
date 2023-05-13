
public class ServerObject {
	
	public int id;
	public int version;
	
	public ServerObject(Integer id) {
		// TODO Auto-generated constructor stub
		this.id = id;
		this.version = 0;
	}

	public int update() {
		// TODO Auto-generated method stub
		return ++this.version;
	}

}
