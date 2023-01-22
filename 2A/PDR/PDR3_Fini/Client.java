import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.ServiceConfigurationError;
import java.lang.reflect.InvocationTargetException;
import java.net.*;

public class Client extends UnicastRemoteObject implements Client_itf {

	private static HashMap<Integer, SharedObject> mapObjects;
	private static Server_itf server;
	public Client() throws RemoteException {
		super();
	}


///////////////////////////////////////////////////
//         Interface to be used by applications
///////////////////////////////////////////////////

	public static void init() {
		Client.mapObjects = new HashMap<Integer, SharedObject>();
		try {
			server = (Server_itf) Naming.lookup(Server.URL);
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static SharedObject lookup(String name) {
		try {
			int id = server.lookup(name);
			//System.out.println("id in client : " + id);
			if(id == -1) return null;
			SharedObject so;
			//Class<?> c = server.lock_read(id, new Client()).getClass();
			Class<?> c = server.getClass(id).getClass();
			c = Class.forName(c.getName() + "_stub");
			so = (SharedObject) c.getDeclaredConstructor(Object.class, int.class).newInstance(null, id);
			mapObjects.put(id, so);
			//System.out.println("so in map in client : " + mapObjects.get(id));
			return so;
		} catch (RemoteException | ClassNotFoundException | InstantiationException | IllegalAccessException | IllegalArgumentException | InvocationTargetException | NoSuchMethodException | SecurityException e) {
			e.printStackTrace();
			return null;
		}
	}		

	public static void register(String name, SharedObject_itf so) {
		SharedObject s = (SharedObject) so;
		try {
			server.register(name, s.id);
			
		} catch (RemoteException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec lors de l'enregistrement de l'objet");
		}	
	}

	public static SharedObject create(Object o) {
		try {
			int id = server.create(o);
			SharedObject so = null;

			//Class<?> c = server.lock_read(id, new Client()).getClass();
			Class<?> c = server.getClass(id).getClass();
			c = Class.forName(c.getName() + "_stub");
			so = (SharedObject) c.getDeclaredConstructor(Object.class, int.class).newInstance(null, id);;

			mapObjects.put(id, so);
			if(so == null) System.out.println("Returned a null so");
			return so;
		}  catch (RemoteException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec lors de la creation de l'objet");
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
		System.out.println("Returned a null so");
		return null;
	}
	
/////////////////////////////////////////////////////////////
//    Interface to be used by the consistency protocol
////////////////////////////////////////////////////////////

	public static Object lock_read(int id) {
		try {
			Object returnObj = server.lock_read(id, new Client());
			//if(returnObj == null) System.out.println("Returned a null obj in lock_read");
			return returnObj;
		}  catch (RemoteException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec du lock_read Client");
		} 
	}

	public static Object lock_write (int id) {
		try {
			Object returnObj = server.lock_write(id, new Client());
			//if(returnObj == null) System.out.println("Returned a null obj in lock_write");
			return returnObj;
		}  catch (RemoteException e) {
			System.out.println("id : " + id);
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec du lock_write Client");
		} 
	}

	public Object reduce_lock(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		return so.reduce_lock();
	}

	public void invalidate_reader(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		//System.out.println("id in invalidate_reader in Client : " + id + " ; so : " + so + " ; taille mapObject : " + mapObjects.size());
		so.invalidate_reader();
	}

	public Object invalidate_writer(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		//System.out.println("obj in invalidate_writer in client : " + so);
		return so.invalidate_writer();
	}

	public static SharedObject getObjectById(int id) {
		if(mapObjects != null) return mapObjects.get(id);
		return null;
	}

	public static void clientValidation(int id){
		try {
			server.clientValidation(id);
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
