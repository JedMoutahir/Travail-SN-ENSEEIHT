import java.rmi.RemoteException;
import java.util.HashMap;

public class Server implements Server_itf {

	HashMap<Integer, Object> objects;
	HashMap<String, Integer> ids;
	
	int lastId = 0;
	
	@Override
	public int lookup(String name) throws RemoteException {
		// TODO Auto-generated method stub
		return this.ids.get(name);
	}

	@Override
	public void register(String name, int id) throws RemoteException {
		// TODO Auto-generated method stub
		this.ids.put(name, id);
	}

	@Override
	public int create(Object o) throws RemoteException {
		// TODO Auto-generated method stub
		this.objects.put(this.lastId+1, o);
		this.lastId ++;
		return this.lastId;
	}

	@Override
	public Object lock_read(int id, Client_itf client) throws RemoteException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Object lock_write(int id, Client_itf client) throws RemoteException {
		// TODO Auto-generated method stub
		return null;
	}

}
