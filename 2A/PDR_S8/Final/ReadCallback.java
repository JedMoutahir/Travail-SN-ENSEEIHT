import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.concurrent.*;

public class ReadCallback extends UnicastRemoteObject implements ReadCallback_itf{

	public int version;
	public Object obj;
	private CyclicBarrier barrier;

	public ReadCallback(int version) throws RemoteException {
		super();
		// TODO Auto-generated constructor stub
		this.version = version;
		this.obj = null;
		this.barrier = new CyclicBarrier(Server.CLIENT_MAX/2+1);
	}

	@Override
	public void reponse(int version, Object obj) throws RemoteException {
		// TODO Auto-generated method stub
		if(version > this.version) {
			this.version = version;
			this.obj = obj;
		}
		try {
			barrier.await();
        } catch (BrokenBarrierException | InterruptedException e) {
            e.printStackTrace();
        }
	}

}