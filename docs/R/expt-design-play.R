letterz <- letters[1:5] # built-in array!
numbers <- 1:length(letterz)
symbols = c(letters, numbers)
symbol_type = rep(c("l", "n"), each=length(numbers))
conds <- data.frame(symbols, symbol_type, stringsAsFactors = FALSE)
conds <- conds[sample(nrow(conds)),]

cond_reps_block <- 10
block <- data.frame(symbols = rep(symbols, cond_reps_block), 
                    symbol_type = rep(symbol_type, cond_reps_block),
                    stringsAsFactors = FALSE,
                    row.names = NULL)

randomize_block_trials <- function(b) {
  if (is.data.frame(b)) {
    b[sample(nrow(b)),]    
  } else {
    NULL 
  }
}

blocks_per_session = 4
session <- data.frame(block_num = rep(1:blocks_per_session, 
                                  each = dim(block)[1]),
                      randomize_block_trials(block),
                      stringsAsFactors = FALSE,
                      row.names = NULL)
