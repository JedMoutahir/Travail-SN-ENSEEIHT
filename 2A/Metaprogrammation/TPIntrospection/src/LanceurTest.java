public class LanceurTest {
	LanceurIndependant lanceur;

	public void testMonnaie1() throws Exception {
		this.lanceur = new LanceurIndependant("MonnaieTest");
		Assert.assertTrue(this.lanceur.getNbTests() == 2 && this.lanceur.getNbEchecs() == 0 && this.lanceur.getNbErreurs() == 0);
	}
	
	public void testMonnaie2() throws Exception {
		this.lanceur = new LanceurIndependant("MonnaieTest2");
		Assert.assertTrue(this.lanceur.getNbTests() == 3 && this.lanceur.getNbEchecs() == 0 && this.lanceur.getNbErreurs() == 0);
	}
	
	public void testCasLimites() throws Exception {
		this.lanceur = new LanceurIndependant("CasLimitesTest");
		Assert.assertTrue(this.lanceur.getNbTests() == 1 && this.lanceur.getNbEchecs() == 0 && this.lanceur.getNbErreurs() == 0);
	}
}
