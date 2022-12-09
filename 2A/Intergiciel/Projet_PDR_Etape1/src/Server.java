import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;

public class Server extends UnicastRemoteObject implements Server_itf {

	HashMap<Integer, ServerObject> ids;
	HashMap<String, ServerObject> names;
	
	int lastId = 0;
	private static int serverPort = 5555;
	
	public Server() throws java.rmi.RemoteException {

        this.names = new HashMap<String, ServerObject>();
        this.ids = new HashMap<Integer, ServerObject>();
        this.lastId = 0;
    }
	
	@Override
	public int lookup(String name) throws RemoteException {
		// TODO Auto-generated method stub
		Object object = this.names.get(name);

        if(object == null)
            return -1;

		return 0;
	}

	@Override
	public void register(String name, int id) throws RemoteException {
		// TODO Auto-generated method stub
		ServerObject o = this.ids.get(id);
        if(o != null) this.names.put(name, o);
	}

	@Override
	public int create(Object o) throws RemoteException {
		// TODO Auto-generated method stub
		ServerObject so = new ServerObject(this.lastId+1, o);
		this.ids.put(so.getId(), so);
		this.lastId ++;
		return this.lastId;
	}

	@Override
	public Object lock_read(int id, Client_itf client) throws RemoteException {
		// TODO Auto-generated method stub
		ServerObject so = this.ids.get(id);
        so.lock_read(client);
        return so.getObject();
	}

	@Override
	public Object lock_write(int id, Client_itf client) throws RemoteException {
		// TODO Auto-generated method stub
		ServerObject so = this.ids.get(id);
        so.lock_write(client);
        return so.getObject();
	}
	
	public static void main(String args[]) throws Exception {

        try {
            LocateRegistry.createRegistry(serverPort);
        }
        catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
            System.out.println("Erreur dans Server.main() : RemoteException");
        }

        Server server = new Server();
        Naming.rebind("//localhost:" + serverPort + "/Server", server);
    }

}
