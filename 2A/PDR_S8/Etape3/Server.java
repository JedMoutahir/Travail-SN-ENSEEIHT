import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class Server extends UnicastRemoteObject implements Server_itf {
	public static final String URL = "//localhost:5555/Server";
	public static final Integer Port = 5555;
	private Set<Client_itf> clientList;
	private HashMap<String, Integer> ids;
	private HashMap<Integer, Object> objects;
	private HashMap<Integer, Integer> versions;
	private int lastid;
	
	public Server() throws RemoteException {
		this.clientList = new HashSet<Client_itf>();
		this.ids = new HashMap<String, Integer>();
		this.objects = new HashMap<Integer, Object>();
		this.versions = new HashMap<Integer, Integer>();
		this.lastid = 0;
		System.out.println("Server init done");
	}
	
	@Override
	public Set<Client_itf> addClient(Client_itf client) throws RemoteException {
		// TODO Auto-generated method stub
		this.clientList.add(client);
		return this.clientList;
	}

	@Override
	public int publish(String name, Object o, boolean reset) throws RemoteException {
		// TODO Auto-generated method stub
		if(this.ids == null) System.out.println("null ids");
		if(this.ids.containsKey(name)) {
			int id = this.ids.get(name);
			this.objects.replace(id, o);
			if (reset) {
				this.versions.replace(id, 0);
			}
			System.out.println("id = " + id);
			System.out.println("this.version.get(id) = " + this.versions.get(id));
			this.versions.replace(id, this.versions.get(id)+1);
			return this.ids.get(name);
		}
		lastid++;
		this.ids.put(name, lastid);
		this.objects.put(lastid, o);
		this.versions.put(lastid, 0);
		System.out.println("this.version.get(" + lastid + ") = " + this.versions.get(lastid));

		return lastid;
	}

	@Override
	public int lookup(String name) throws RemoteException {
		// TODO Auto-generated method stub
		return this.ids.get(name);
	}

	@Override
	public int write(int idObjet, Object valeur) throws RemoteException {
		// TODO Auto-generated method stub
		this.objects.replace(idObjet, valeur);
		this.versions.replace(idObjet, this.versions.get(idObjet)+1);
		return this.versions.get(idObjet);
	}

	public static void main(String[] args) {
		try {
			Registry registre = LocateRegistry.createRegistry(Server.Port);
			Server Serveur = new Server();
			Naming.rebind(Server.URL, Serveur);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
