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
	private HashMap<Client_itf, Integer> subscriberRecord;

	protected Server() throws RemoteException {
		super();
		mapServerObjects = new HashMap<Integer, ServerObject>();
		mapID = new HashMap<String, Integer>();
		subscriberRecord = new HashMap<Client_itf, Integer>();
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
	public void abonner(Client_itf client, String name) {
		// TODO Auto-generated method stub
		try {
			subscriberRecord.put(client, this.lookup(name));
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void desabonner(Client_itf client, String name) {
		// TODO Auto-generated method stub
		try {
			subscriberRecord.remove(client, this.lookup(name));
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void notifier(int id, Object obj) {
		mapServerObjects.put(id, new ServerObject(obj, id));
		for(Map.Entry<Client_itf, Integer> set : subscriberRecord.entrySet()) {
			if(set.getValue() == id) {
				try {
					set.getKey().callback(id, obj);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
}
