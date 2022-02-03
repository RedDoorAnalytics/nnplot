//local drive Z:/
local drive /Users/Michael/Documents/reddooranalytics/products

cd "`drive'/nnplot"
adopath ++ "`drive'/nnplot/nnplot"
pr drop _all

set scheme s2gcolor
// set scheme black_hue

nnplot , inputs(10) outputs(5) hlayers(3) hnodes(8 3 4)  //title("")
graph export "/Users/Michael/Documents/reddooranalytics/posts/nnplot2.jpg", replace

nnplot , inputs(15) outputs(1) hlayers(3) hnodes(10 8 6)  //title("")
graph export "/Users/Michael/Documents/reddooranalytics/posts/nnplot3.jpg", replace
