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

	HashMap<LOCKS, Integer> locks;
	
	HashMap<SharedObject, Integer> objects;
	
	public Client() throws RemoteException {
		super();
	}


///////////////////////////////////////////////////
//         Interface to be used by applications
///////////////////////////////////////////////////

	// initialization of the client layer
	public static void init() {
	}
	
	// lookup in the name server
	public static SharedObject lookup(String name) {
		
	}		
	
	// binding in the name server
	public static void register(String name, SharedObject_itf so) {
	}

	// creation of a shared object
	public static SharedObject create(Object o) {
	}
	
/////////////////////////////////////////////////////////////
//    Interface to be used by the consistency protocol
////////////////////////////////////////////////////////////

	// request a read lock from the server
	public static Object lock_read(int id) {
		
	}

	// request a write lock from the server
	public static Object lock_write (int id) {
	}

	// receive a lock reduction request from the server
	public Object reduce_lock(int id) throws java.rmi.RemoteException {
	}


	// receive a reader invalidation request from the server
	public void invalidate_reader(int id) throws java.rmi.RemoteException {
	}


	// receive a writer invalidation request from the server
	public Object invalidate_writer(int id) throws java.rmi.RemoteException {
	}
}
