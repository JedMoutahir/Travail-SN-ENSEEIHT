import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;

public class StubGenerator {
	public static void main(String[] argv) throws IOException {
		if (argv.length != 1) {
			System.out.println("java StubGenerator <interface>");
			return;
		}

		StubGenerator generator = new StubGenerator();
		String className = argv[0].split("_")[0];
		try {
			Class<?> clazz = Class.forName(className);
			String stubName = className + "_stub";
			PrintWriter writer = new PrintWriter(stubName + ".java", "UTF-8");
			writer.println("public class " + stubName + " extends SharedObject implements " + className + "_itf, java.io.Serializable {");
			writer.println("\t" + stubName + "(Object o, int id) {");
			writer.println("\t\tsuper(o, id);");
			writer.println("\t}");
			for (Method method : clazz.getDeclaredMethods()) {
				String returnType = method.getReturnType().getCanonicalName();
				String methodName = method.getName();
				Class<?>[] paramTypes = method.getParameterTypes();
				String args = "";
				String params = "";
				for (int i = 0; i < paramTypes.length; i++) {
					String type = paramTypes[i].getCanonicalName();
					String arg = "p" + i;
					args += type + " " + arg + ", ";
					params += arg + ", ";
				}
				if (args.length() > 0) {
					args = args.substring(0, args.length() - 2);
					params = params.substring(0, params.length() - 2);
				}
				writer.println("\tpublic " + returnType + " " + methodName + "(" + args + ") {");
				writer.println("\t\t" + className + " o = (" + className + ") obj;");
				if (!returnType.equals("void")) {
					writer.print("\t\treturn o." + methodName + "(" + params + ");");
				} else {
					writer.print("\t\to." + methodName + "(" + params + ");");
				}
				writer.println();
				writer.println("\t}");
			}
			writer.println("}");
			writer.close();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
}