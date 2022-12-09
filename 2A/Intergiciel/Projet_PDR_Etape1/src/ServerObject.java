import java.rmi.RemoteException;
import java.util.LinkedList;

public class ServerObject {
	enum serverLOCKS {
		NL,
		RLT,
		WLT
	}

	private int id;

	private serverLOCKS lock;
	private LinkedList<Client_itf> clientsToLock;
	private Object object;

	public ServerObject(int id, Object object) {

		this.id = id;
		this.lock = serverLOCKS.NL;
		this.clientsToLock = new LinkedList<Client_itf>();
		this.object = object;
	}
	
	public int getId() {
		return this.id;
	}

	public Object getObject() {
		return this.object;
	}
	
	public void lock_read(Client_itf client) {
		if(this.lock == serverLOCKS.WLT) {
            if(!this.clientsToLock.getFirst().equals(client)) {
                try {
					this.object = this.clientsToLock.getFirst().reduce_lock(this.id);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            }
        }

		this.lock = serverLOCKS.RLT;

        if(!this.clientsToLock.contains(client)) this.clientsToLock.add(client);
	}
	
	public void lock_write(Client_itf client) {
		if(this.lock == serverLOCKS.WLT) {
            if(!this.clientsToLock.getFirst().equals(client)) {
                try {
					this.object = this.clientsToLock.getFirst().invalidate_writer(this.id);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            }
            this.clientsToLock.clear();
        } else if(this.lock == serverLOCKS.RLT) {
            for(Client_itf readingClient : this.clientsToLock) {
	            if(!readingClient.equals(client)) {
	                try {
						readingClient.invalidate_reader(this.id);
					} catch (RemoteException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	            }
            }
            this.clientsToLock.clear();
        }

		this.lock = serverLOCKS.WLT;

		this.clientsToLock.add(client);
    }
	
}
