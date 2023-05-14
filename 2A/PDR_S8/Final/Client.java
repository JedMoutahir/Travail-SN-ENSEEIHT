import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.*;

public class Client extends UnicastRemoteObject implements Client_itf {
	
	public static Moniteur monitor;
	public static String id;
	private static Map<Integer, SharedObject> sharedTable;
	private static Server_itf serverStub;
	private static Client_itf c;
	private static Set<Client_itf> clients;
	
	protected Client() throws RemoteException {
		super();
		// TODO Auto-generated constructor stub
	}

	static String address = "//localhost:4444/Server";
	
	static Client_itf me;

	public static void init(String name) {
		 id = name;
	        sharedTable = new HashMap<Integer, SharedObject>();
	        try {
	            Registry dns = LocateRegistry.getRegistry(4444);
	            serverStub = (Server_itf) dns.lookup("Server");
	            c = new Client();
	            clients = serverStub.addClient(c);
	            //System.out.println(clients.size());
	            monitor = serverStub.getMonitor();
	        } catch (Exception e) {
	            System.out.println("Can't initialize client layer, see stacktrace for more information.");
	            e.printStackTrace();
	            System.exit(1);
	        }
	}

	public static String getIdSite() {
		return id;
	}
	
	@Override
	public void initSO(int idObj, Object valeur) throws RemoteException {
		// TODO Auto-generated method stub
		SharedObject so = new SharedObject(idObj, valeur);
        sharedTable.put(idObj, so);
	}

	@Override
	public void reportValue(int idObj, ReadCallback_itf rcb) throws RemoteException {
		// TODO Auto-generated method stub
		sharedTable.get(idObj).reportValue(rcb);
	}

	@Override
	public void update(int idObj, int version, Object valeur, WriteCallback_itf wcb) throws RemoteException {
		// TODO Auto-generated method stub
		sharedTable.get(idObj).update(version, valeur, wcb);
	}

	@Override
	public String getSite() throws RemoteException {
		// TODO Auto-generated method stub
		return id;
	}

	@Override
	public Object getObj(String name) throws RemoteException {
		// TODO Auto-generated method stub
		int idname = serverStub.lookup(name);
		return sharedTable.get(idname);
	}

	@Override
	public int getVersion(String name) throws RemoteException {
		// TODO Auto-generated method stub
		int idname = serverStub.lookup(name);
		return sharedTable.get(idname).getVersion();
	}

	public static int write(int id2, Object o) {
		// TODO Auto-generated method stub
		try {
			int version = serverStub.write(id2, o, c);
			return version;
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}

	public static SharedObject lookup(String name) {
		// TODO Auto-generated method stub
		try {
            int id = serverStub.lookup(name);
            if(id == -1) return null;

            return sharedTable.get(id);
        } catch (RemoteException e) {
        	System.out.println("Can't connect to server, see stacktrace for more information.");
            e.printStackTrace();
            System.exit(1);
        }

        return null;
	}

	public static SharedObject publish(String name, Object o) {
		// TODO Auto-generated method stub
		 try {
	            int id = serverStub.lookup(name);

	            if(id == -1) id = serverStub.publish(name, o);

	            return sharedTable.get(id);
	        } catch (RemoteException e) {
	        	System.out.println("Can't connect to server, see stacktrace for more information.");
	            e.printStackTrace();
	            System.exit(1);
	        }

	        return null;
	}
	
	public static void read(int id, ReadCallback_itf rcb) {
		for (Client_itf client : clients) {
            Thread t = new Thread(() -> {
                try {
                	if(!c.equals(client)) client.reportValue(id, rcb);
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
            });
            t.start();
        }
		//TODO STOP CLIENT (peut-etre semaphore)
		try {
			rcb.reponse(-1, null);
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Client_itf)) return false;
        if (this.hashCode() == ((Client_itf)o).hashCode()) return true;
        return false;
    }

}
