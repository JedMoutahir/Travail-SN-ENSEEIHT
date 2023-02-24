import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class Server extends UnicastRemoteObject implements Server_itf {

	private static final long serialVersionUID = 1L;
	public static final String URL = "//localhost:4444/Server";
	public static final Integer Port = 4444;
	private HashMap<Integer, ServerObject> mapServerObjects;
	private HashMap<String, Integer> mapID;

	protected Server() throws RemoteException {
		super();
		mapServerObjects = new HashMap<Integer, ServerObject>();
		mapID = new HashMap<String, Integer>();
	}

	@Override
	public int lookup(String name) throws RemoteException {
		if (mapID.get(name) == null) {
			return -1;
		} else {
			return mapID.get(name);
		}
	}

	@Override
	public void register(String name, int id) throws RemoteException {
		mapID.put(name,id);
	}

	@Override
	public int create(Object o) throws RemoteException {
		int id = mapServerObjects.size();
		ServerObject so = new ServerObject(o,id);
		mapServerObjects.put(id,so);
		return id;
	}

	@Override
	public Object lock_read(int id, Client_itf client) throws RemoteException {
		ServerObject so = mapServerObjects.get(id);
		return so.lock_read(client);
	}

	@Override
	public Object lock_write(int id, Client_itf client) throws RemoteException {
		ServerObject so = mapServerObjects.get(id);
		return so.lock_write(client);
	}

	public static void main(String[] args) {
		try {
			Registry registre = LocateRegistry.createRegistry(Port);
			Server Serveur = new Server();
			Naming.rebind(Server.URL, Serveur);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public Object getClass(int id) throws RemoteException {
		// TODO Auto-generated method stub
		return mapServerObjects.get(id).obj;
	}

	@Override
	public void clientValidation(int id) throws RemoteException {
		// TODO Auto-generated method stub
		mapServerObjects.get(id).clientValidation();
	}

	@Override
	public void abonner(Client_itf client, int id) throws RemoteException {
		// TODO Auto-generated method stub
		//System.out.println("abonner dans server");
		ServerObject so = mapServerObjects.get(id);
		so.abonner(client);
	}

	@Override
	public void desabonner(Client_itf client, int id) throws RemoteException {
		// TODO Auto-generated method stub
		ServerObject so = mapServerObjects.get(id);
		so.desabonner(client);
	}
	
	public void notifier(int id, Object newObject) {
		// TODO Auto-generated method stub
		ServerObject so = mapServerObjects.get(id);
		so.notifier(newObject);
	}
}