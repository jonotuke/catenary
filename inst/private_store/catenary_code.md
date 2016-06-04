Title:  Catenary Package Design  
Author: Matthew Roughan  
Date:   2013
Affiliation: University of Adelaide  
XHTML Header: <script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>


# Catenary package design

Fundamental equation of the catenary is given by
\\[
 y = c_1  \cosh( (x-c_2)/c_1 ) + \lambda
\\]

## Catenary object

### member variables

    c_1 = shape parameter
    	    c_1 > 0 for common catenary
	        c_1 = 0 is a limiting case which is a horizontal line
            c_1 < 0 is an inverted catenary, used for arches
    c_2 = x-location parameter
    lambda = y-location parameter
    (x_0,y_0) = left end point
    (x_1,y_1) = right end point: x_0 <= x_1
    L = length

### member functions

#### constructors

    new(x_0,y_0,x_1,y_1)   // take end-points, and estimate natural catenary
    new(x_0,y_0,x_1,y_1,L) // take end-points, and length, and estimate parameters
    new(x,y)               // take vectors x and y, and estimate parameters for catenary, 
	                       // using non-linear least squares 

#### calculation of the curve

    f(x)
        input  x = vector of points, x_0 <= x <= x_1
        output y = c_1 * cosh( (x - c_2)/c_1 ) + lambda

#### information functions

    vertex = (c_2, c_1 + \lambda)
    min_y = c_1 + \lambda, if c_1 > 0
	        min(y_0, y_1), if c_1 < 0
    max_y = max(y_0, y_1), if c_1 > 0
	        c_1 + \lambda, if c_1 < 0
	dip = max_y - min_y  // assumes c_1 > 0, otherwise it would be a rise
    slope = sinh((x-c_2)/c_1)
	radius of curvature = y^2/c_1

    center_of_mass
	tension (at a point x, given mass per unit distance, and gravitational const)
	
#### output

    plot( linewidth, linestyle, end-point marker, pylons(yes/no) , ...)
           // plot the catenary with some nice options
    print  // write out key parameters of a catenary

## Other 'utility' functions

    min_length(x_0,y_0,x_1,y_1) // calculate the minimum length of a catenary with given end points
           \\[ output = \sqrt{ (x_1-x_0)^2 + (y_1 - y_0)^2 } \\]

    max_length(x_0,y_0,x_1,y_1)
           algorithm is a bit more complicated

    approximate: get approximating parabola for a catenary
	             or perhaps approximating degree n polynomial

## Examples:

We also need a set of simple examples to show:
* how to use the functions
* illustrations of various cases
* to use as test cases to validate the code

## Design comments:

The goal is to use constructors to estimate correct parameters and
other details using overloading to deal with different types of
inputs. 

There should be an equivalent estimation for parabolas, and circular
arcs, in order to replicate the comparison results?

A question is: should there be a super-class called the infinite catenary which doesn't have 
end points? Then plotting doesn't have a fixed range?

Another question is how we should return diagnostics from estimation (and other constructors).
Should there be a set of appropriate variables in the class, e.g., RSS, or should the function
not be a constructor?

In finding the natural catenary we have to deal with the fact that 2,1, or 0 catenaries can fit 
the end-points, even if only one is valid. The other may be of interest in some cases, and when
no solution exists we need to report this in a sensible way.

The constructors also need to check that inputs are valid, e.g., the length is in the range 
between max and min, using the appropriate utility functions.

## V2.0 features

### linked lists of catenaries

Catenaries that are joined, in order, kept in a list. Enforce that the end-points connect?

### catenary constructors for new problems

* overlength catenaries (resulting in a linked list)
* catenaries with a free end


## V3.0 features

Generalized forms of catenary:
* elastic catenaries
* flattened catenaries
* weighted catenaries
* elliptic and hyperbolic catenaries
* catenoids
* paul bunyan's clothes line
* inflexible catenary


# Algorithms

## estimation of parameters from a set of points [x,y]

Use the constructor

    new(x,y)       
	
where x and y are length n vectors, for n>2.	
	
Algorithm:
   
    1. estimate a parabola through the set of points, and write in the form
	        y = a x^2 + b x + c
	   which we can simplify by completing the square to give
		    y = ( sign(a) sqrt(a) (x + b/(2 sqrt(a)) )    )^2  - [b^2/2a - c]

    2. Use the parabola to obtain initial estimates for the catenary
		 c_2 = -b/(2*a);
		 c_1 = sign(a)/sqrt(a);
		 lambda = c - b^2/(4*a) - c_1;
	   by identifying elements of the parabola with the catenary.	 

    3. Use non-linear least square to estimate more accurate values of 
	   the parameters, along with errors, covariances.
	   
	4. Calculate the end points by taking
	       x0 = min(x)
		   y0 = f(x0)
		   x1 = max(x)
		   y1 = f(x1)
		   L = c_1*[ sinh((x_1-c_2)/c_1) - sinh((x_0-c_2)/c_1) ]

    5. Creates the catenary object, but also we need some way to
       output errors, and covariances -- maybe the object should include
	   such member variables?
	
## calculation of the parameters from fixed end points, and the length

Use the constructor

	new(x_0,y_0,x_1,y_1,L)

Algorithm:

    1. Check that the length is valid, i.e., that
	      L > min_length(x_0,y_0,x_1,y_1)
	      L < max_length(x_0,y_0,x_1,y_1)
	
		  NB: in later versions we can deal with L>max_length using the
		  overlength catenary.
	
        If invalid, return a meaningful error.
	
	2. Assume we are looking for a hanging chain (not an arch), so the 
	   curve will have c_1>0
	   
		
	
## calculation of the parameters with unspecified length

In this case we look for the natural catenary, which has \\(\lambda = 0\\).

Use the constructor

	new(x_0,y_0,x_1,y_1)

Algorithm:

    1. lambda = 0
	
	2. 
	
