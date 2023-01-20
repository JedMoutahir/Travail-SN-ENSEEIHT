
public class TestBruteForce {
	public static void main(String[] args) {
		
		int nbThreads = Integer.parseInt(args[0]);
		Thread[] threads = new Thread[nbThreads];
		
		Client.init();
		IntContainer_itf nbContainer = (IntContainer_itf) Client.lookup("nb");

		if (nbContainer == null) {
			nbContainer = (IntContainer_itf) Client.create(new IntContainer());
			Client.register("nb", nbContainer);
		}
		
		nbContainer.lock_write();
		nbContainer.put(0);
		nbContainer.unlock();
		
		for(int i = 0 ; i < nbThreads ; i++) {
//			System.out.println("Created thread number : " + i);
			Thread clientThread = new Thread(new clientPlus1());
			threads[i] = clientThread;
		}

		for(int i = 0 ; i < nbThreads ; i++) {
			threads[i].start();
		}
		
		for(int i = 0 ; i < nbThreads ; i++) {
			try {
				threads[i].join();
//				System.out.println("Joined thread number : " + i);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		nbContainer.lock_read();
		System.out.println("final value read : " + nbContainer.get() + " expected : " + nbThreads);
		nbContainer.unlock();
	}
}
