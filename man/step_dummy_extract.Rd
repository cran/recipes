% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dummy_extract.R
\name{step_dummy_extract}
\alias{step_dummy_extract}
\title{Extract patterns from nominal data}
\usage{
step_dummy_extract(
  recipe,
  ...,
  role = "predictor",
  trained = FALSE,
  sep = NULL,
  pattern = NULL,
  threshold = 0,
  other = "other",
  naming = dummy_extract_names,
  levels = NULL,
  sparse = "auto",
  keep_original_cols = FALSE,
  skip = FALSE,
  id = rand_id("dummy_extract")
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

\item{sep}{Character string containing a regular expression to use for
splitting. \code{\link[=strsplit]{strsplit()}} is used to perform the split. \code{sep} takes priority
if \code{pattern} is also specified.}

\item{pattern}{Character string containing a regular expression used for
extraction. \code{\link[=gregexpr]{gregexpr()}} and \code{\link[=regmatches]{regmatches()}} are used to perform pattern
extraction using \code{perl = TRUE}.}

\item{threshold}{A numeric value between 0 and 1, or an integer greater or
equal to one.  If less than one, then factor levels with a rate of
occurrence in the training set below \code{threshold} will be pooled to \code{other}.
If greater or equal to one, then this value is treated as a frequency and
factor levels that occur less than \code{threshold} times will be pooled to
\code{other}.}

\item{other}{A single character value for the other category, default to
\code{"other"}.}

\item{naming}{A function that defines the naming convention for new dummy
columns. See Details below.}

\item{levels}{A list that contains the information needed to create dummy
variables for each variable contained in \code{terms}. This is \code{NULL} until the
step is trained by \code{\link[=prep]{prep()}}.}

\item{sparse}{A single string. Should the columns produced be sparse vectors.
Can take the values \code{"yes"}, \code{"no"}, and \code{"auto"}. If \code{sparse = "auto"}
then workflows can determine the best option. Defaults to \code{"auto"}.}

\item{keep_original_cols}{A logical to keep the original variables in the
output. Defaults to \code{FALSE}.}

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
\code{step_dummy_extract()} creates a \emph{specification} of a recipe step that will
convert nominal data (e.g. characters or factors) into one or more integer
model terms for the extracted levels.
}
\details{
\code{step_dummy_extract()} will create a set of integer dummy variables from a
character variable by extracting individual strings by either splitting or
extracting then counting those to create count variables.

Note that \code{threshold} works in a very specific way for this step. While it is
possible for one label to be present multiple times in the same row, it will
only be counted once when calculating the occurrences and frequencies.

This recipe step allows for flexible naming of the resulting
variables. For an unordered factor named \code{x}, with levels \code{"a"}
and \code{"b"}, the default naming convention would be to create a
new variable called \code{x_b}. The naming format can be changed using
the \code{naming} argument; the function \code{\link[=dummy_names]{dummy_names()}} is the
default.
}
\section{Tidying}{
When you \code{\link[=tidy.recipe]{tidy()}} this step, a tibble is returned with
columns \code{terms}, \code{columns} , and \code{id}:

\describe{
\item{terms}{character, the selectors or variables selected}
\item{columns}{character, names of resulting columns}
\item{id}{character, id of this step}
}

The return value is ordered according to the frequency of \code{columns} entries
in the training data set.
}

\section{Sparse data}{


This step produces sparse columns if \code{sparse = "yes"} is being set. The
default value \code{"auto"} won't trigger production fo sparse columns if a recipe
is \code{\link[=prep]{prep()}}ed, but allows for a workflow to toggle to \code{"yes"} or \code{"no"}
depending on whether the model supports \link{sparse_data} and if the model is
is expected to run faster with the data.

The mechanism for determining how much sparsity is produced isn't perfect,
and there will be times when you want to manually overwrite by setting
\code{sparse = "yes"} or \code{sparse = "no"}.
}

\section{Case weights}{


This step performs an unsupervised operation that can utilize case weights.
As a result, case weights are only used with frequency weights. For more
information, see the documentation in \link{case_weights} and the examples on
\code{tidymodels.org}.
}

\examples{
\dontshow{if (rlang::is_installed("modeldata")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
data(tate_text, package = "modeldata")

dummies <- recipe(~ artist + medium, data = tate_text) \%>\%
  step_dummy_extract(artist, medium, sep = ", ") \%>\%
  prep()

dummy_data <- bake(dummies, new_data = NULL)

dummy_data \%>\%
  select(starts_with("medium")) \%>\%
  names() \%>\%
  head()

# More detailed splitting
dummies_specific <- recipe(~medium, data = tate_text) \%>\%
  step_dummy_extract(medium, sep = "(, )|( and )|( on )") \%>\%
  prep()

dummy_data_specific <- bake(dummies_specific, new_data = NULL)

dummy_data_specific \%>\%
  select(starts_with("medium")) \%>\%
  names() \%>\%
  head()

tidy(dummies, number = 1)
tidy(dummies_specific, number = 1)

# pattern argument can be useful to extract harder patterns
color_examples <- tibble(
  colors = c(
    "['red', 'blue']",
    "['red', 'blue', 'white']",
    "['blue', 'blue', 'blue']"
  )
)

dummies_color <- recipe(~colors, data = color_examples) \%>\%
  step_dummy_extract(colors, pattern = "(?<=')[^',]+(?=')") \%>\%
  prep()

dummies_data_color <- dummies_color \%>\%
  bake(new_data = NULL)

dummies_data_color
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=dummy_extract_names]{dummy_extract_names()}}

Other dummy variable and encoding steps: 
\code{\link{step_bin2factor}()},
\code{\link{step_count}()},
\code{\link{step_date}()},
\code{\link{step_dummy}()},
\code{\link{step_dummy_multi_choice}()},
\code{\link{step_factor2string}()},
\code{\link{step_holiday}()},
\code{\link{step_indicate_na}()},
\code{\link{step_integer}()},
\code{\link{step_novel}()},
\code{\link{step_num2factor}()},
\code{\link{step_ordinalscore}()},
\code{\link{step_other}()},
\code{\link{step_regex}()},
\code{\link{step_relevel}()},
\code{\link{step_string2factor}()},
\code{\link{step_time}()},
\code{\link{step_unknown}()},
\code{\link{step_unorder}()}
}
\concept{dummy variable and encoding steps}
