*! version 1.0.0 03feb2022 MJC

program define nnplot
	syntax 	,			///
                                        ///
                INputs(string)		/// -# of inputs-							
                OUTputs(string)		/// -# of outputs-
                                        ///
        [				///
                HLAYERS(string)		/// -number of hidden layers-
                HNodes(string)		/// -number of nodes per hidden layer-
                COLORS(string)		/// 
                INLabels(string)	///
                OUTLabels(string)	///
                HLabel(string)		///
                *			///
        ]	                        
										
	local Ninputs = `inputs'
	local Nops = `outputs'
	if "`colors'"=="" {
		local colors navy forest_green maroon purple red
	}
	
	if "`inlabels'"=="" {
		forval i=1/`Ninputs' {
			local inlab x`i' `inlab' 
		}
	}
	else {
		local nol : word count of `inlabels'
		if `nol'!=`Ninputs' {
			di as error "Number of inlabels() incorrect"
			exit 198
		}
		local inlab `inlabels'
	}
	
	if "`outlabels'"=="" {
		forval i=1/`Nops' {
			local outlab y`i' `outlab' 
		}
	}
	else {
		local nol : word count of `outlabels'
		if `nol'!=`Nops' {
			di as error "Number of outlabels() incorrect"
			exit 198
		}
	}
	
	if "`hlabel'"=="" {
		local hlabel "Hidden layer"
	}
	
	//intercept of inputs
// 	local Ninputs = `Ninputs' + 1
// 	local inlab `inlab' b0
	
	//hidden layers
	
	if "`hlayers'"=="" {
		local hlayers = 1
	}
	else {
		if `hlayers'<1 {
			di as error "hlayers() must be >=1"
			exit 198
		}
	}
	
	if "`hnodes'"=="" {
		local hnodes = 1
	}
	
	local Nhn : list sizeof hnodes
	if `Nhn'!=`hlayers' & `Nhn'!=1 {
		di as error "Wrong number of elements in hnodes()"
		exit 198
	}
	
	if `hlayers'>1 & `Nhn'==1 {
		local chnodes `hnodes'
		local hnodes
		forval i=1/`hlayers' {
			local hnodes `hnodes' `chnodes'
		}
	}
	
	//plots all nodes
	local textlab "Inputs"
	forval i=1/`hlayers' {
		local textlab `textlab' "`hlabel' `i'"
	}
	local textlab `textlab' "Outputs"
	local Nlayers = `hlayers' + 2
	local nodes `Ninputs' `hnodes' `Nops'
	
	forval i=1/`Nlayers' {
		local Nn : word `i' of `nodes'
		cap set obs `Nn'
		tempvar xn`i' yn`i'
		qui gen `xn`i'' = `i'/(`Nlayers'+1) in 1/`Nn'
		qui gen `yn`i'' = _n * (1/(`Nn'+1)) if _n<=`Nn'
		
		//input labels
		if `i'==1 {
			tempvar ilab
			qui gen `ilab' = "" in 1/`Nn'
			forval j=1/`Ninputs' {
				qui replace `ilab' = "{it:`: word `j' of `inlab''}" in `=`j''
			}
			local mlab`i' mlabel(`ilab') mlabpos(9) mlabgap(2) mlabcolor(`: word `i' of `colors'')
		}
		
		//output labels
		if `i'==`Nlayers' {
			tempvar olab
			qui gen `olab' = "" in 1/`Nn'
			forval j=1/`Nops' {
				qui replace `olab' = "{it:`: word `j' of `outlab''}" in `=`j''
			}
			local mlab`i' mlabel(`olab') mlabpos(3) mlabgap(2) mlabcolor(`: word `i' of `colors'')
		}
		
		local graph `graph' (scatter `yn`i'' `xn`i'', msymbol(O) msize(vlarge) mcolor(`:word `i' of `colors'') `mlab`i'')
		local text `text' text(0 `=`i'/(`Nlayers'+1)' "{it:`: word `i' of `textlab''}", size(small))
	}
	
	//=================================================================================================================//
	//arrows
	
	local hid = 1
	while `hid'<`Nlayers' {
		
		local hid2 = `hid'+1
		local Nn : word `hid' of `nodes'
		local Nn2 : word `hid2' of `nodes'
		
		forval i=1/`Nn' {
			tempvar xi`hid'`i' yi`hid'`i'
			qui gen `xi`hid'`i'' = `xn`hid''[`i'] in 1/`Nn2'
			qui gen `yi`hid'`i'' = `yn`hid''[`i'] in 1/`Nn2'
			
			local graph `graph' (pcarrow `yi`hid'`i'' `xi`hid'`i'' `yn`hid2'' `xn`hid2'', mcolor(`:word `hid' of `colors'') lcolor(`:word `hid' of `colors''))
			
		}
		local hid = `hid' + 1
	}
	
	//=================================================================================================================//
	//final
		
	twoway `graph', 		                        ///
                ytitle("") xtitle("")				///
                title("Artificial neural network") 		///
                /*graphregion(m(zero))*/				///
                legend(off)					///
                yscale(range(-0.05 1.05) off) ylabel(none)	///
                xscale(range(0 1) off) xlabel(none)		///
                `text' `options'
	
	
end
