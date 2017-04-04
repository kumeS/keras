

#' Input layer
#' 
#' Layer to be used as an entry point into a graph.
#' 
#' @param shape Shape, not including the batch size. For instance, 
#'   `shape=c(32)` indicates that the expected input will be batches
#'   of 32-dimensional vectors.
#' @param batch_shape Shapes, including the batch size. For instance, 
#'   `batch_shape=c(10, 32)` indicates that the expected input will be
#'   batches of 10 32-dimensional vectors. `batch_shape=list(NULL, 32)`
#'   indicates batches of an arbitrary number of 32-dimensional vectors.
#' @param name An optional name string for the layer. Should be unique in a 
#'   model (do not reuse the same name twice). It will be autogenerated if it 
#'   isn't provided.
#' @param dtype  The data type expected by the input, as a string (`float32`, 
#'   `float64`, `int32`...)
#' @param sparse Boolean, whether the placeholder created is meant to be sparse.
#' @param tensor Existing tensor to wrap into the `Input` layer. If set, the
#'   layer will not create a placeholder tensor.
#'   
#' @details It can either wrap an existing tensor (pass an `input_tensor` 
#'   argument) or create its a placeholder tensor (pass arguments `input_shape` 
#'   or `batch_input_shape` as well as `input_dtype`).
#'   
#' @return A tensor   
#'   
#' @family core layers   
#'   
#' @export
layer_input <- function(shape = NULL, batch_shape = NULL, name = NULL,
                        dtype = NULL, sparse = FALSE, tensor = NULL) {
  keras$layers$Input(
    shape = normalize_shape(shape),
    batch_shape = normalize_shape(batch_shape),
    name = name,
    dtype = ifelse(is.null(dtype), keras$backend$floatx(), dtype),
    sparse = sparse,
    tensor = tensor
  )
}

#' Add a densely-connected NN layer to an output
#' 
#' Implements the operation: `output = activation(dot(input, kernel) + bias)` 
#' where `activation` is the element-wise activation function passed as the 
#' `activation` argument, `kernel` is a weights matrix created by the layer, and
#' `bias` is a bias vector created by the layer (only applicable if `use_bias` 
#' is `TRUE`). Note: if the input to the layer has a rank greater than 2, then 
#' it is flattened prior to the initial dot product with `kernel`.
#' 
#' @param x Model or layer
#' @param units Positive integer, dimensionality of the output space.
#' @param activation Name of activation function to use. If you don't specify 
#'   anything, no activation is applied (ie. "linear" activation: a(x) = x).
#' @param use_bias Whether the layer uses a bias vector.
#' @param kernel_initializer Initializer for the `kernel` weights matrix.
#' @param bias_initializer Initializer for the bias vector.
#' @param kernel_regularizer Regularizer function applied to the `kernel` 
#'   weights matrix.
#' @param bias_regularizer Regularizer function applied to the bias vector.
#' @param activity_regularizer Regularizer function applied to the output of the
#'   layer (its "activation")..
#' @param kernel_constraint Constraint function applied to the `kernel` weights 
#'   matrix.
#' @param bias_constraint  Constraint function applied to the bias vector.
#' @param input_shape Dimensionality of the input (integer) not including the
#'   samples axis. This argument is required when using this layer as the first
#'   layer in a model.
#'   
#' @section Input and Output Shapes:
#'   
#'   Input shape: nD tensor with shape: `(batch_size, ..., input_dim)`. The most
#'   common situation would be a 2D input with shape `(batch_size, input_dim)`.
#'   
#'   Output shape: nD tensor with shape: `(batch_size, ..., units)`. For 
#'   instance, for a 2D input with shape `(batch_size, input_dim)`, the output 
#'   would have shape `(batch_size, unit)`.
#' 
#' @family core layers   
#'       
#' @export
layer_dense <- function(x, units, activation = NULL, use_bias = TRUE, 
                        kernel_initializer = 'glorot_uniform', bias_initializer = 'zeros', 
                        kernel_regularizer = NULL, bias_regularizer = NULL, activity_regularizer = NULL,
                        kernel_constraint = NULL, bias_constraint = NULL, input_shape = NULL
                        ) {
  
  call_layer(keras$layers$Dense, x, list(
    units = as.integer(units),
    activation = resolve_keras_function(activation),
    use_bias = use_bias,
    kernel_initializer = kernel_initializer,
    bias_initializer = bias_initializer,
    kernel_regularizer = kernel_regularizer,
    bias_regularizer = bias_regularizer,
    activity_regularizer = activity_regularizer,
    kernel_constraint = kernel_constraint,
    bias_constraint = bias_constraint, 
    input_shape = normalize_shape(input_shape)
  ))
  
}

#' Reshapes an output to a certain shape.
#' 
#' @inheritParams layer_activation
#'   
#' @param target_shape List of integers, does not include the samples dimension 
#'   (batch size).
#'   
#' @section Input and Output Shapes:
#'   
#'   Input shape: Arbitrary, although all dimensions in the input shaped must be
#'   fixed.
#'   
#'   Output shape: `(batch_size,) + target_shape`.
#' 
#' @family core layers   
#'   
#' @export
layer_reshape <- function(x, target_shape, input_shape = NULL) {
  
  call_layer(keras$layers$Reshape, x, list(
    target_shape = normalize_shape(target_shape),
    input_shape = normalize_shape(input_shape)
  ))
  
}


#' Permute the dimensions of an input according to a given pattern
#' 
#' @param dims List of integers. Permutation pattern, does not include the 
#'   samples dimension. Indexing starts at 1. For instance, `(2, 1)` permutes 
#'   the first and second dimension of the input.
#'   
#' @inheritParams layer_activation
#'   
#' @section Input and Output Shapes:
#'   
#'   Input shape: Arbitrary
#'   
#'   Output shape: Same as the input shape, but with the dimensions re-ordered
#'   according to the specified pattern.
#'   
#' @note Useful for e.g. connecting RNNs and convnets together.
#'   
#' @family core layers   
#'   
#' @export
layer_permute <- function(x, dims, input_shape = NULL) {
  
  call_layer(keras$layers$Permute, x, list(
    dims = list(as.integer(dims)),
    input_shape = normalize_shape(input_shape)       
  ))
  
}

#' Repeats the input n times.
#' 
#' @inheritParams layer_dense
#' 
#' @param n integer, repetition factor.
#'   
#' @section Input shape: 2D tensor of shape `(num_samples, features)`.
#'   
#' @section Output shape: 3D tensor of shape `(num_samples, n, features)`.
#'   
#' @family core layers   
#'   
#' @export
layer_repeat_vector <- function(x, n) {
  
  call_layer(tf$contrib$keras$layers$RepeatVector, x, list(
    n = as.integer(n)
  ))
  
}

#' Wraps arbitrary expression as a layer
#' 
#' @inheritParams layer_dense
#' 
#' @param f The function to be evaluated. Takes input tensor as first
#'   argument.
#' @param mask mask
#' @param arguments optional named list of keyword arguments to be passed to the
#'   function.
#'   
#' @section Input shape: Arbitrary. Use the keyword argument input_shape (list
#'   of integers, does not include the samples axis) when using this layer as
#'   the first layer in a model.
#'   
#' @section Output shape: Arbitrary (based on tensor returned from the function)
#'  
#' @family core layers   
#'     
#' @export
layer_lambda <- function(x, f, mask = NULL, arguments = NULL, input_shape = NULL) {
  
  call_layer(tf$contrib$keras$layers$Lambda, x, list(
    `function` = f,
    mask = mask,
    arguments = arguments,
    input_shape = normalize_shape(input_shape)
  ))
  
}


#' Layer that applies an update to the cost function based input activity.
#' 
#' @inheritParams layer_dense
#' 
#' @param l1 L1 regularization factor (positive float).
#' @param l2 L2 regularization factor (positive float).
#'   
#' @section Input shape: Arbitrary. Use the keyword argument `input_shape` (list
#'   of integers, does not include the samples axis) when using this layer as
#'   the first layer in a model.
#'   
#' @section Output shape: Same shape as input.
#' 
#' @family core layers   
#'       
#' @export
layer_activity_regularization <- function(x, l1 = 0.0, l2 = 0.0, input_shape = NULL) {
  
  call_layer(tf$contrib$keras$layers$ActivityRegularization, x, list(
    l1 = l1,
    l2 = l2,
    input_shape = normalize_shape(input_shape)
  ))
  
}

#' Masks a sequence by using a mask value to skip timesteps.
#' 
#' For each timestep in the input tensor (dimension #1 in the tensor), if all
#' values in the input tensor at that timestep are equal to `mask_value`, then
#' the timestep will be masked (skipped) in all downstream layers (as long as
#' they support masking). If any downstream layer does not support masking yet
#' receives such an input mask, an exception will be raised.
#' 
#' @inheritParams layer_dense
#' 
#' @param mask_value float, mask value
#'   
#' @family core layers   
#'   
#' @export
layer_masking <- function(x, mask_value = 0.0, input_shape = NULL) {
  
  call_layer(tf$contrib$keras$layers$Masking, x, list(
    mask_value = mask_value,
    input_shape = normalize_shape(input_shape)
  ))
  
}



#' Flattens an input
#' 
#' Flatten a given input, does not affect the batch size.
#' 
#' @inheritParams layer_activation
#' 
#' @family core layers
#' 
#' @export
layer_flatten <- function(x) {
  
  call_layer(keras$layers$Flatten, x, list())
  
}

as_integer_tuple <- function(x) {
  if (is.null(x))
    x
  else
    tuple(as.list(as.integer(x)))
}

as_nullable_integer <- function(x) {
  if (is.null(x))
    x
  else
    as.integer(x)
}


# Helper function to coerce shape arguments to tuple
normalize_shape <- function(shape) {
  
  # reflect NULL back
  if (is.null(shape))
    shape
  
  # if it's a list or a numeric vector then convert to integer
  else if (is.list(shape) || is.numeric(shape))
    shape <- lapply(shape, function(value) {
      if (!is.null(value))
        as.integer(value)
      else
        NULL
    })
  
  # coerce to tuple so it's iterable    
  tuple(shape)
}


# Helper function to call a layer
call_layer <- function(layer_function, x, args) {
  
  # remove input_shape if it's NULL (needs to be missing to signal it's not in use)
  args$input_shape <- args$input_shape
  
  # call function
  layer <- do.call(layer_function, args)
  
  # compose if we have an x
  if (missing(x) || is.null(x))
    layer
  else
    compose_layer(x, layer)
}



# Helper function to compose a layer with an object of type Model or Layer
compose_layer <- function(x, layer) {
  
  # if a sequential is passed then add it to the model
  if (is_sequential_model(x)) {
    
    x$add(layer)
    x
    
  # if a layer is passed then wrap the layer
  } else if (is_layer(x)) {
    
    py_call(layer, x)
    
  # otherwie it's an unexpected type
  } else {
    
    stop("Invalid input to layer function (must be a model or a tensor)",
         call. = FALSE)
  }
}

is_sequential_model <- function(x) {
  inherits(x, "tensorflow.contrib.keras.python.keras.models.Sequential")
}

is_layer <- function(x) {
  inherits(x, "tensorflow.python.framework.ops.Tensor") ||
  inherits(x, "tensorflow.contrib.keras.python.keras.engine.topology.Layer")
}

