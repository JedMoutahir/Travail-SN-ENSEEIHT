import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.rmi.registry.*;
import java.net.*;

public class Client extends UnicastRemoteObject implements Client_itf {

	enum LOCKS {
		NL,
		RLT,
		RLC,
		WLT,
		WLC,
		RLT_WLC
	}


	public static Client_itf client;
	private static Server_itf server;
	private static String serverPort = "5555";
	HashMap<LOCKS, Integer> locks;

	private static HashMap<Integer, SharedObject> objects;

	public Client() throws RemoteException {
		super();
	}


	///////////////////////////////////////////////////
	//         Interface to be used by applications
	///////////////////////////////////////////////////

	// initialization of the client layer
	public static void init() {
		try {
			client = new Client();
		}
		catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Erreur dans Client.init() lors de la création du client");
		}

		try {
			server = (Server_itf) Naming.lookup("//localhost:" + serverPort +"/Server");
		}
		catch(MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Erreur dans Client.init() : URL mal formée");
		}
		catch(RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Erreur dans Client.init() : RemoteException");
		}
		catch(NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Erreur dans Client.init() : NotBoundException");
		}

		assert(server != null);
		objects = new HashMap<Integer, SharedObject>();
	}

	// lookup in the name server
	public static SharedObject lookup(String name) {
		int id = 0;
		
		try {
			id = server.lookup(name);
		} catch(RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		SharedObject so = null;
		
		if(id != -1) {
			so = objects.get(id);
			if(so == null) {
				so = new SharedObject(id);
				objects.put(id, so);
			}
		}
		return so;
	}		

	// binding in the name server
	public static void register(String name, SharedObject_itf soi) {
		SharedObject so = (SharedObject) soi;
		
		try {
			server.register(name, so.id);
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		objects.put(so.id, so);
	}

	// creation of a shared object
	public static SharedObject create(Object o) {
		SharedObject so = null;
		try {
			so = new SharedObject(server.create(o));
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return so;
	}

	/////////////////////////////////////////////////////////////
	//    Interface to be used by the consistency protocol
	////////////////////////////////////////////////////////////

	// request a read lock from the server
	public static Object lock_read(int id) {
		Object o = null;
        try {
            o = server.lock_read(id, client);
        } catch(RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
        }
        return o;
	}

	// request a write lock from the server
	public static Object lock_write (int id) {
		Object o = null;
        try {
            o = server.lock_write(id, client);
        } catch(RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
        }
        return o;
	}

	// receive a lock reduction request from the server
	public Object reduce_lock(int id) throws java.rmi.RemoteException {
		return this.objects.get(id).reduce_lock();
	}


	// receive a reader invalidation request from the server
	public void invalidate_reader(int id) throws java.rmi.RemoteException {
		this.objects.get(id).invalidate_reader();
	}


	// receive a writer invalidation request from the server
	public Object invalidate_writer(int id) throws java.rmi.RemoteException {
		return this.objects.get(id).invalidate_writer();
	}
}
