
public class clientPlus1 implements Runnable {

	@Override
	public void run() {
		// TODO Auto-generated method stub
		IntContainer_itf nbContainer = (IntContainer_itf) Client.lookup("nb");

		if (nbContainer == null) {
			System.out.println("nb was not found");
		}
		
		nbContainer.lock_write();
		nbContainer.put(nbContainer.get()+1);
		nbContainer.unlock();
	}

}
