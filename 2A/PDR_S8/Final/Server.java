import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.*;

public class Server extends UnicastRemoteObject implements Server_itf {
	public static final String URL = "//localhost:4444/Server";
	public static final Integer Port = 4444;
	public static final int CLIENT_MAX = 5;
	private Set<Client_itf> clientList;
	private HashMap<String, Integer> ids;
	private HashMap<Integer, ServerObject> objects;
	private CyclicBarrier barrier;
	private Semaphore waitClients;
	private Moniteur monitor;
	private Integer id;
	
	public Server() throws RemoteException {
		this.clientList = new HashSet<Client_itf>();
		this.ids = new HashMap<String, Integer>();
		this.objects = new HashMap<Integer, ServerObject>();
		this.id = 0;
		this.barrier = new CyclicBarrier(CLIENT_MAX);
		this.waitClients = new Semaphore(0);

		System.out.println("Server init done");
	}
	
	@Override
	public Set<Client_itf> addClient(Client_itf client) throws RemoteException {
		// TODO Auto-generated method stub
		this.clientList.add(client);
		try {
            this.barrier.await();
        } catch (InterruptedException | BrokenBarrierException e) {
            e.printStackTrace();
        }
		this.waitClients.release();
		return this.clientList;
	}

	@Override
	public int publish(String name, Object o) throws RemoteException {
		// TODO Auto-generated method stub
		synchronized (this) {
            if (!this.ids.containsKey(name)) {
                ServerObject so = new ServerObject(this.id);
                this.objects.put(this.id, so);
                this.ids.put(name, this.id);

                for(Client_itf c : this.clientList) {
                    c.initSO(this.id, o);
                } 

                return this.id++;

            } else return this.ids.get(name);
        }
	}

	@Override
	public int lookup(String name) throws RemoteException {
		// TODO Auto-generated method stub
		Integer id = this.ids.get(name);

        if (id == null) return -1;
		return id;
	}

	@Override
	public int write(int idObjet, Object valeur, Client_itf sender) throws RemoteException {
		// TODO Auto-generated method stub
		ServerObject so = this.objects.get(idObjet);
        // Le serveur g�re tous les num�ros de version, donc on se fie � lui pour le dernier,
        // En fait, on �crase le num�ro du writer (au cas o� le writer n'�tait pas � jour)
        int version = so.update();

        WriteCallback_itf wcb = (WriteCallback_itf) new WriteCallback();

        for (Client_itf client : clientList) {
            Thread t = new Thread(() -> {
                try {
                    if (!sender.equals(client)) {
                        client.update(idObjet, version, valeur, wcb);
                    }
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
            });
            t.start();
        }
        return version;
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

	@Override
	public String[] list() throws RemoteException {
		// TODO Auto-generated method stub
		String[] list = new String[this.id];
        Set<String> keySet = this.ids.keySet();
        int i = 0;

        for (String s : keySet) {
            list[i] = s;
            i++;
        }

        return list;
	}

	@Override
	public Set<Client_itf> setMonitor(Moniteur m) throws RemoteException {
		// TODO Auto-generated method stub
		try {
            this.waitClients.acquire();
            this.waitClients.release();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
		this.monitor = m;
		return this.clientList;
	}

	@Override
	public Moniteur getMonitor() throws RemoteException {
		// TODO Auto-generated method stub
		return this.monitor;
	}
}