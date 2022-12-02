import java.util.*;
import java.lang.annotation.*;

@Documented
@Retention(RetentionPolicy.RUNTIME)
@interface UnTest {

	boolean enabled() default true;
	
	public static class nullException extends Exception {
		nullException(String message){
			super(message);
		}
	}
	
	Class<?extends Throwable> expected() default nullException.class;
}
