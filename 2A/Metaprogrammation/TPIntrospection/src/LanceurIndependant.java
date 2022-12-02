import java.lang.reflect.*;
import java.util.*;

/** L'objectif est de faire un lanceur simple sans utiliser toutes les clases
  * de notre architecture JUnit.   Il permet juste de valider la compréhension
  * de l'introspection en Java.
  */
public class LanceurIndependant {
	private int nbTestsLances;
	private int nbErreurs;
	private int nbEchecs;
	private List<Throwable> erreurs = new ArrayList<>();

	public LanceurIndependant(String... nomsClasses) {
	    System.out.println();

		// Lancer les tests pour chaque classe
		for (String nom : nomsClasses) {
			try {
				System.out.print(nom + " : ");
				this.testerUneClasse(nom);
				System.out.println();
			} catch (ClassNotFoundException e) {
				System.out.println(" Classe inconnue !");
			} catch (Exception e) {
				System.out.println(" Problème : " + e);
				e.printStackTrace();
			}
		}

		// Afficher les erreurs
		for (Throwable e : erreurs) {
			System.out.println();
			e.printStackTrace();
		}

		// Afficher un bilan
		System.out.println();
		System.out.printf("%d tests lancés dont %d échecs et %d erreurs.\n",
				nbTestsLances, nbEchecs, nbErreurs);
	}


	public int getNbTests() {
		return this.nbTestsLances;
	}


	public int getNbErreurs() {
		return this.nbErreurs;
	}


	public int getNbEchecs() {
		return this.nbEchecs;
	}


	private void testerUneClasse(String nomClasse)
		throws ClassNotFoundException, InstantiationException,
						  IllegalAccessException
	{
		Class classe = null;
		// Récupérer la classe
		try {
			classe = Class.forName(nomClasse);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// Récupérer les méthodes "preparer" et "nettoyer"
		Method preparer = null;
		Method nettoyer = null;
		try {
			preparer = classe.getMethod("preparer");
		} catch (NoSuchMethodException e1) {
			// TODO Auto-generated catch block
			System.out.println("Pas de Méthode preparer.");
		} catch (SecurityException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		try {
			nettoyer = classe.getMethod("nettoyer");
		} catch (NoSuchMethodException e1) {
			// TODO Auto-generated catch block
			System.out.println("Pas de Méthode nettoyer.");
		} catch (SecurityException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	
		// Instancier l'objet qui sera le récepteur des tests
		Object objet = null;
		try {
			objet = classe.getConstructor().newInstance();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// Exécuter les méthods de test
		try {
			Method[] methods = classe.getMethods();
			ArrayList<Method> tests = new ArrayList<Method>();
			for(Method m : methods) {
				if(m.getName().startsWith("test") && m.getParameterCount() == 0 && !Modifier.isStatic(m.getModifiers())) {
					tests.add(m);
				}
			}
			for(Method t : tests) {
				System.out.println("Test de " + t.getName());
				this.nbTestsLances ++;

				if(preparer != null) preparer.invoke((classe.cast(objet)));
				
				t.invoke((classe.cast(objet)));

				if(nettoyer != null) nettoyer.invoke(objet);
			}
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			this.nbEchecs++;
			this.erreurs.add(e);
			e.getCause();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			this.nbErreurs++;
			e.printStackTrace();
		}
	}

	public static void main(String... args) {
		LanceurIndependant lanceur = new LanceurIndependant(args);
	}

}
