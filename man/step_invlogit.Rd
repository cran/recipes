% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/invlogit.R
\name{step_invlogit}
\alias{step_invlogit}
\title{Inverse logit transformation}
\usage{
step_invlogit(
  recipe,
  ...,
  role = NA,
  trained = FALSE,
  columns = NULL,
  skip = FALSE,
  id = rand_id("invlogit")
)
}
\arguments{
\item{recipe}{A recipe object. The step will be added to the sequence of
operations for this recipe.}

\item{...}{One or more selector functions to choose variables for this step.
See \code{\link[=selections]{selections()}} for more details.}

\item{role}{Not used by this step since no new variables are created.}

\item{trained}{A logical to indicate if the quantities for preprocessing have
been estimated.}

\item{columns}{A character string of the selected variable names. This field
is a placeholder and will be populated once \code{\link[=prep]{prep()}} is used.}

\item{skip}{A logical. Should the step be skipped when the recipe is baked by
\code{\link[=bake]{bake()}}? While all operations are baked when \code{\link[=prep]{prep()}} is run, some
operations may not be able to be conducted on new data (e.g. processing the
outcome variable(s)). Care should be taken when using \code{skip = TRUE} as it
may affect the computations for subsequent operations.}

\item{id}{A character string that is unique to this step to identify it.}
}
\value{
An updated version of \code{recipe} with the new step added to the
sequence of any existing operations.
}
\description{
\code{step_invlogit()} creates a \emph{specification} of a recipe step that will
transform the data from real values to be between zero and one.
}
\details{
The inverse logit transformation takes values on the real line and translates
them to be between zero and one using the function \code{f(x) = 1/(1+exp(-x))}.
}
\section{Tidying}{
When you \code{\link[=tidy.recipe]{tidy()}} this step, a tibble is returned with
columns \code{terms} and \code{id}:

\describe{
\item{terms}{character, the selectors or variables selected}
\item{id}{character, id of this step}
}
}

\section{Case weights}{


The underlying operation does not allow for case weights.
}

\examples{
\dontshow{if (rlang::is_installed("modeldata")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
data(biomass, package = "modeldata")

biomass_tr <- biomass[biomass$dataset == "Training", ]
biomass_te <- biomass[biomass$dataset == "Testing", ]

rec <- recipe(
  HHV ~ carbon + hydrogen + oxygen + nitrogen + sulfur,
  data = biomass_tr
)

ilogit_trans <- rec |>
  step_center(carbon, hydrogen) |>
  step_scale(carbon, hydrogen) |>
  step_invlogit(carbon, hydrogen)

ilogit_obj <- prep(ilogit_trans, training = biomass_tr)

transformed_te <- bake(ilogit_obj, biomass_te)
plot(biomass_te$carbon, transformed_te$carbon)
\dontshow{\}) # examplesIf}
}
\seealso{
Other individual transformation steps: 
\code{\link{step_BoxCox}()},
\code{\link{step_YeoJohnson}()},
\code{\link{step_bs}()},
\code{\link{step_harmonic}()},
\code{\link{step_hyperbolic}()},
\code{\link{step_inverse}()},
\code{\link{step_log}()},
\code{\link{step_logit}()},
\code{\link{step_mutate}()},
\code{\link{step_ns}()},
\code{\link{step_percentile}()},
\code{\link{step_poly}()},
\code{\link{step_relu}()},
\code{\link{step_sqrt}()}
}
\concept{individual transformation steps}
