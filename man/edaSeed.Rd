\name{edaSeed}

\alias{edaSeed}
\alias{edaSeedUniform}

\title{Seeding Methods}

\description{
Methods for the \code{edaSeed} generic function.
}

\usage{
edaSeedUniform(eda, lower, upper)
}

\arguments{
\item{eda}{\code{\linkS4class{EDA}} instance.}
  
\item{lower}{Lower bounds of the variables of the objective function.}
  
\item{upper}{Upper bounds of the variables of the objective function.}
}

\details{
Seeding methods create the initial population. The length of the \code{lower}
and \code{upper} vectors determine the number of variables of the objective 
function. The following seeding methods are implemented.

\describe{
  \item{\code{edaSeedUniform}}{Sample each variable from a continuous uniform
    distribution in the interval determined by \code{lower} and \code{upper}. 
    The parameter \code{popSize} sets the number of solutions in the population 
    (default value: \code{100}). This is the default method of the 
    \code{edaSeed} generic function.}
}
}

\value{
A matrix with one column for each variable of the objective function and one
row for each solution in the population.
}

\references{
González-Fernández Y and Soto M (2012). copulaedas: An R Package for
Estimation of Distribution Algorithms Based on Copulas. Preprint
\href{http://arxiv.org/abs/1209.5429}{arXiv:1209.5429 [cs.NE]}.
}