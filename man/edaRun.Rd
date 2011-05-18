\name{edaRun}

\alias{edaRun}
\alias{edaLearn}
\alias{edaSample}

\title{Main Loop of an EDA}

\description{
Implementation of the main loop of an EDA.
}

\usage{
edaRun(eda, f, lower, upper)
}

\arguments{
  \item{eda}{An \code{\linkS4class{EDA}} instance.}

  \item{f}{Objective function}

  \item{lower}{Lower bounds of the variables of the objective function.}
  
  \item{upper}{Upper bounds of the variables of the objective function.}
}

\details{
EDAs are implemented using S4 classes with generic functions for its main parts: 
seeding (\code{\link{edaSeed}}), selection (\code{\link{edaSelect}}), 
learning (\code{edaLearn}), sampling (\code{edaSample}), replacement 
(\code{\link{edaReplace}}), local optimization (\code{\link{edaOptimize}}), 
termination (\code{\link{edaTerminate}}), and reporting (\code{\link{edaReport}}). 
All classes implementing EDAs should inherit from the \code{\linkS4class{EDA}} 
class.

The following pseudocode illustrates the interactions between all the generic 
functions that implement the main parts of the EDA. It is a simplified version 
of the implementation of the \code{\link{edaRun}} function.

\preformatted{
gen <- 0 # Counts the number of generations.
fEvals <- 0 # Counts the number of evaluations
            # of the objective function.
terminate <- FALSE

while (!terminate) {
    gen <- gen + 1

    if (gen == 1) {
        model <- NULL

        pop <- edaSeed(eda, lower, upper)

        # Set the popEval vector to the evaluation 
        # of the objective function for each 
        # individual in pop. fEvals is updated.

        r <- edaOptimize(eda, gen, pop, popEval,
                         f, lower, upper)
        pop <- r$pop
        popEval <- r$popEval
    } else {
        s <- edaSelect(eda, gen, pop, popEval)
        selectedPop <- pop[s, ]
        selectedEval <- popEval[s]

        model <- edaLearn(eda, gen, model, selectedPop,
                          selectedEval, lower, upper)

        sampledPop <- edaSample(eda, gen, model, 
                                lower, upper)

        # Set the sampledEval vector to the evaluation 
        # of the objective function for each individual 
        # in sampledPop. fEvals is updated.

        r <- edaOptimize(eda, gen, sampledPop, 
                         sampledEval, f, lower, upper) 
        sampledPop <- r$pop
        sampledEval <- r$popEval
        
        r <- edaReplace(eda, gen, pop, popEval, 
                        sampledPop, sampledEval)
        pop <- r$pop
        popEval <- r$popEval
    }

    edaReport(eda, gen, fEvals, model, pop, popEval)

    terminate <- edaTerminate(eda, gen, fEvals, 
                              pop, popEval)
}
}
}

\value{
An \code{\linkS4class{EDAResult}} instance.
}

\seealso{
\code{\linkS4class{EDA}},
\code{\linkS4class{EDAResult}},
\code{\link{edaIndepRuns}}.
}

\examples{
setMethod("edaReport", "EDA", edaReportSimple)
setMethod("edaTerminate", "EDA",
          edaTerminateCombined(edaTerminateMaxGen,
                               edaTerminateEval))

DVEDA <- VEDA(vine = "DVine", copulas = c("normal"),
              indepTestSigLevel = 0.01, fmargin = fnorm,
              pmargin = pnorm, qmargin = qnorm, popSize = 200, 
              maxGens = 50, fEval = 0, fEvalTol = 1e-03)
DVEDA@name <- "D-vine Estimation of Distribution Algorithm"

result <- edaRun(DVEDA, fSphere, rep(-600, 5), rep(600, 5))

show(result)
}