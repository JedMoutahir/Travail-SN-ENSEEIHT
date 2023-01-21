import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.ServiceConfigurationError;
import java.lang.reflect.InvocationTargetException;
import java.net.*;

public class Client extends UnicastRemoteObject implements Client_itf {

	private static HashMap<Integer, SharedObject> mapObjects;
	
	public Client() throws RemoteException {
		super();
	}


///////////////////////////////////////////////////
//         Interface to be used by applications
///////////////////////////////////////////////////

	// initialization of the client layer
	public static void init() {
		Client.mapObjects = new HashMap<Integer, SharedObject>();
	}
	
	// lookup in the name server
	public static SharedObject lookup(String name) {
		try {
			Server_itf server = (Server_itf) Naming.lookup(Server.URL);
			int id = server.lookup(name);
			SharedObject so = mapObjects.get(id);
			
			if (id != -1 && so == null) {
				Class<?> c = server.lock_read(id, new Client()).getClass();
				c = Class.forName(c.getName() + "_stub");
				so = (SharedObject) c.getDeclaredConstructor(Object.class, int.class).newInstance(null, id);
				mapObjects.put(id, so);
			}
			
			return so;
		} catch (MalformedURLException | RemoteException | NotBoundException | ClassNotFoundException | InstantiationException | IllegalAccessException | IllegalArgumentException | InvocationTargetException | NoSuchMethodException | SecurityException e) {
			e.printStackTrace();
			return null;
		}
		
	}		
	
	// binding in the name server
	public static void register(String name, SharedObject_itf so) {
		SharedObject s = (SharedObject) so;
		try {
			Server_itf server = (Server_itf) Naming.lookup(Server.URL);
			server.register(name, s.id);
			
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec lors de l'enregistrement de l'objet");
		}	
	}

	// creation of a shared object
	public static SharedObject create(Object o) {
		try {
			Server_itf server = (Server_itf) Naming.lookup(Server.URL);
			int id = server.create(o);
			SharedObject so = null;

			Class<?> c = server.lock_read(id, new Client()).getClass();
			c = Class.forName(c.getName() + "_stub");
			so = (SharedObject) c.getDeclaredConstructor(Object.class, int.class).newInstance(null, id);;

			mapObjects.put(id, so);
			return so;
		}  catch (MalformedURLException | RemoteException | NotBoundException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec lors de la création de l'objet");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
/////////////////////////////////////////////////////////////
//    Interface to be used by the consistency protocol
////////////////////////////////////////////////////////////

	// request a read lock from the server
	public static Object lock_read(int id) {
		try {
			Server_itf server = (Server_itf) Naming.lookup(Server.URL);
			return server.lock_read(id, new Client());
		}  catch (MalformedURLException | RemoteException | NotBoundException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec du lock_read Client");
		} 
	}

	// request a write lock from the server
	public static Object lock_write (int id) {
		try {
			Server_itf server = (Server_itf) Naming.lookup(Server.URL);
			return server.lock_write(id, new Client());
		}  catch (MalformedURLException | RemoteException | NotBoundException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec du lock_write Client");
		} 
	}

	// receive a lock reduction request from the server
	public Object reduce_lock(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		return so.reduce_lock();
	}


	// receive a reader invalidation request from the server
	public void invalidate_reader(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		so.invalidate_reader();
	}


	// receive a writer invalidation request from the server
	public Object invalidate_writer(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		return so.invalidate_writer();
	}

	public static SharedObject getObjectById(int id) {
		return mapObjects.get(id);
	}
	
}
