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
				System.out.println(nom + " : ");
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
		Method preparer = getPreparer(classe);
		Method nettoyer = getNettoyer(classe);

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
				if(m.isAnnotationPresent(UnTest.class) && m.getParameterCount() == 0 && !Modifier.isStatic(m.getModifiers())) {
					if(m.getAnnotation(UnTest.class).enabled()) tests.add(m);
				}
			}
			for(Method t : tests) {
				System.out.println("Test de " + t.getName());
				this.nbTestsLances ++;

				if(preparer != null) preparer.invoke((classe.cast(objet)));

				try {
					t.invoke((classe.cast(objet)));
				} catch (Exception e) {
					if(e.getClass() != UnTest.nullException.class && e.getClass() != t.getAnnotation(UnTest.class).expected()) {
						this.nbEchecs++;
						this.erreurs.add(e);
					}
					throw e;
				}
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

	private static Method getPreparer(Class classe) {
		Method[] methods = classe.getMethods();
		for(Method m : methods) {
			if(m.isAnnotationPresent(Avant.class)) {
				return m;
			}
		}
		return null;
	}

	private static Method getNettoyer(Class classe) {
		Method[] methods = classe.getMethods();
		for(Method m : methods) {
			if(m.isAnnotationPresent(Apres.class)) {
				return m;
			}
		}
		return null;
	}

	public static void main(String... args) {
		LanceurIndependant lanceur = new LanceurIndependant(args);
	}

}
