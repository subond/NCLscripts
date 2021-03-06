load "$NCARG_ROOT/lib/ncarg/nclex/gsun/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

print("Lanczos_Filter_Time")
Direc = getenv("NCL_ARG_1")
nexps = toint(getenv("NCL_ARG_2"))
Experiments = new(nexps,"string")

do ne = 0,nexps-1
        Experiments(ne) = getenv("NCL_ARG_" + tostring(3+ne))
end do


startyr = toint(getenv("NCL_ARG_" + tostring(3+nexps)))
endyr = toint(getenv("NCL_ARG_" + tostring(4+nexps)))
secs = getenv("NCL_ARG_" + tostring(5+nexps))

print(startyr*1)
print(endyr*1)

nyears = endyr-startyr+1

timespan = "DJF"

dimsexps = dimsizes(Experiments)
nexps = dimsexps(0)

do exps = 0,nexps-1
        Experiment = Experiments(exps)
        Dir = (Direc + Experiment + "/atm/hist/")
        print(Experiment)

	filename = Dir + "Eddy_250_850_Annual" + tostring(startyr) + "_" + tostring(nyears) + "_" + Experiment + ".cam2.h1.nc"

	cdf_file = addfile(filename,"r")

	lat = cdf_file->lat
	lon = cdf_file->lon
	sizearray = cdf_file->U850eddy

	ndims = dimsizes(sizearray)

	time  = cdf_file->time
; ***********************************************
; create the filter weights and apply
; ***********************************************
	ihp     = 2                             ; band pass
	sigma   = 1.0                           ; Lanczos sigma

	nWgt    = 1461                           ; 1461 lose half a year at each end = 2*740+1 = 1461  

	dt = 0.25                                ; days per timestep
  
	fca     = dt/6.                        ; low freq, 6 days = 1/24 timesteps
	fcb     = dt/2.                        ; high freq = 2 days = 1/8 timesteps

	wgt     = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )


	inputvars = (/"U850","U250","V850","V250","TH850","TH250")
	;Loop over variables
	nvars = dimsizes(inputvars)
 
	do ivar = 0,nvars -1
		variable = inputvars(ivar)
	
		if (variable .eq. "U850") then
			invar = cdf_file->U850eddy
		else if (variable .eq. "U250") then
			invar = cdf_file->U250eddy
		else if (variable .eq. "V850") then
			invar = cdf_file->V850eddy
		else if (variable .eq. "V250") then
			invar = cdf_file->V250eddy
		else if (variable .eq. "TH850") then
			invar = cdf_file->TH850
		else if (variable .eq. "TH250") then
			invar = cdf_file->TH250
		else
			print("unrecognised variable requested")
			print(variable)	
			exit
		end if
		end if
		end if
		end if
		end if
		end if
	
		bpf_temp = new(ndims,typeof(sizearray))
	
		do ilat = 0,ndims(1)-1
			do ilon = 0,ndims(2)-1
				bpf_temp(:,ilat,ilon) = wgt_runave (invar(:,ilat,ilon), wgt, 0 )      ;
			end do
		end do
	
		ndims = dimsizes(bpf_temp)
		ntimes = ndims(0)
	
		bpf_temp!0 = invar!0
		bpf_temp!1 = invar!1
		bpf_temp!2 = invar!2
		delete(invar)
		
		count = 0
		if (timespan .eq. "Annual") then
		        ntAnn = nyears*4*(365);
	       		bpf = new((/ntAnn,ndims(1),ndims(2)/),typeof(bpf_temp))
	        	timebpf = new((/ntAnn/),typeof(time))
	        	do nt = 731,ntimes-731
	                        bpf(count,:,:) = bpf_temp(nt,:,:)
	                        timebpf(count) = time(nt)
	                        count = count + 1
			end do
		else if (timespan .eq. "DJF") then
		        nDJF = nyears*4*(31+28+31);
	       		bpf = new((/nDJF,ndims(1),ndims(2)/),typeof(bpf_temp))
	        	timebpf = new((/nDJF/),typeof(time))
	
			do nt = 731,ntimes-731
			        year = floor(time(nt)/10000.)
        	                month = floor((time(nt) - 10000. * year)/100.)
				if (month .eq. 12 .or. month .eq. 1 .or. month .eq. 2)
					bpf(count,:,:) = bpf_temp(nt,:,:)
					timebpf(count) = time(nt)
					count = count + 1
        	                else if (month .gt. 12 .or. month .lt. 1)
        	                        print("months not quite right!")
        	                        exit
        	                        end if
        	                end if
			end do
		else if (timespan .eq. "JJA") then
        	        nJJA = nyears*4*(31+28+31);
        	        bpf = new((/nJJA,ndims(1),ndims(2)/),typeof(bpf_temp))
        	        timebpf = new((/nJJA/),typeof(time))
	
	                do nt = 731,ntimes-731
	                        year = floor(time(nt)/10000.)
	                        month = floor((time(nt) - 10000. * year)/100.)
	
	                        if (month .eq. 6 .or. month .eq. 7 .or. month .eq. 8)
	                                bpf(count,:,:) = bpf_temp(nt,:,:)
	                                timebpf(count) = time(nt)
	                                count = count + 1
	                        else if (month .gt. 12 .or. month .lt. 1)
	                                print("months not quite right!")
	                                exit
	                        end if
	                        end if
	                end do
		else
			print("timespan incorrect, options Annual, DJF or JJA")
	
		end if
		end if
		end if
		
		bpf!0 = bpf_temp!0
		bpf!1 = bpf_temp!1
		bpf!2 = bpf_temp!2
		
		delete(bpf_temp)
		ndims2 = dimsizes(bpf(0:count-1,:,:))
		
	
	; if first variable, then create file
		if ivar = 0 then
			filo = "EKE_VT_EV_bpf_" + timespan + tostring(startyr) + "_" + tostring(nyears) + "_" + Experiment + ".cam2.h1.nc"
			system("/bin/rm -f " + Dir + filo)
			fout_std = addfile(Dir + filo, "c")
	
			setfileoption(fout_std,"DefineMode",True)
	
		;set attributes of output file
			fAtt = True
			fAtt@creation_date = systemfunc("date")
			fileattdef(fout_std,fAtt)
		
		;set dimensions of output file
			dimNames = (/"time","lat","lon"/)
			dimSizes = (/ndims2(0),ndims2(1),ndims2(2)/)
			dimUnlim = (/True,False,False/)
			filedimdef(fout_std,dimNames,dimSizes,dimUnlim)
		
			filevardef(fout_std,"time",typeof(time),getvardims(time))
			filevardef(fout_std,"lat",typeof(lat),getvardims(lat))
			filevardef(fout_std,"lon",typeof(lon),getvardims(lon))
		
			filevardef(fout_std,"U850tdash_bpf",typeof(bpf),getvardims(bpf))
			filevardef(fout_std,"U250tdash_bpf",typeof(bpf),getvardims(bpf))
			filevardef(fout_std,"V850tdash_bpf",typeof(bpf),getvardims(bpf))
			filevardef(fout_std,"V250tdash_bpf",typeof(bpf),getvardims(bpf))
			
			filevardef(fout_std,"U850tdash_bpf_2",typeof(bpf),getvardims(bpf))
			filevardef(fout_std,"U250tdash_bpf_2",typeof(bpf),getvardims(bpf))
			filevardef(fout_std,"V850tdash_bpf_2",typeof(bpf),getvardims(bpf))
			filevardef(fout_std,"V250tdash_bpf_2",typeof(bpf),getvardims(bpf))

                        filevardef(fout_std,"TH850tdash_bpf",typeof(bpf),getvardims(bpf))
                        filevardef(fout_std,"TH250tdash_bpf",typeof(bpf),getvardims(bpf))
		
			filevardef(fout_std,"EKE850tdash_bpf",typeof(bpf),getvardims(bpf))
			filevardef(fout_std,"EKE250tdash_bpf",typeof(bpf),getvardims(bpf))
		
		; write standard outputs
			fout_std->time = timebpf(0:count-1)
	
			fout_std->lat = lat
			fout_std->lon = lon
		end if

	        if (variable .eq. "U850") then
		        fout_std->U850tdash_bpf = (/bpf(0:count-1,:,:)/)
	        else if (variable .eq. "U250") then
	                fout_std->U250tdash_bpf = (/bpf(0:count-1,:,:)/)
		else if (variable .eq. "V850") then
	                fout_std->V850tdash_bpf = (/bpf(0:count-1,:,:)/)
	        else if (variable .eq. "V250") then
	                fout_std->V250tdash_bpf = (/bpf(0:count-1,:,:)/)
	        else if (variable .eq. "TH850") then
	                fout_std->TH850tdash_bpf = (/bpf(0:count-1,:,:)/)
	        else if (variable .eq. "TH250") then
	                fout_std->TH250tdash_bpf = (/bpf(0:count-1,:,:)/)
	        else
	                print("unrecognised variable requested for writing")
	                print(variable)
	                exit
	        end if
        	end if
        	end if
        	end if
        	end if
        	end if
	
		delete([/lat,lon,timebpf,bpf/])
	
	end do

	delete(cdf_file)
	
; Calculate products

	U850bpf_2 = fout_std->U850tdash_bpf*fout_std->U850tdash_bpf
	U850bpf_2!0 = fout_std->U850tdash_bpf!0
	U850bpf_2!1 = fout_std->U850tdash_bpf!1
	U850bpf_2!2 = fout_std->U850tdash_bpf!2
	print("calc U^2 850")

	fout_std->U850tdash_bpf_2 = (/U850bpf_2/)

	delete(U850bpf_2)

	V850bpf_2 = fout_std->V850tdash_bpf*fout_std->V850tdash_bpf
	V850bpf_2!0 = fout_std->V850tdash_bpf!0
	V850bpf_2!1 = fout_std->V850tdash_bpf!1
	V850bpf_2!2 = fout_std->V850tdash_bpf!2
	print("calc V^2 850")

	fout_std->V850tdash_bpf_2 = (/V850bpf_2/)

	delete(V850bpf_2)

	U250bpf_2 = fout_std->U250tdash_bpf*fout_std->U250tdash_bpf
	U250bpf_2!0 = fout_std->U250tdash_bpf!0
	U250bpf_2!1 = fout_std->U250tdash_bpf!1
	U250bpf_2!2 = fout_std->U250tdash_bpf!2
	print("calc U^2 250")

	fout_std->U250tdash_bpf_2 = (/U250bpf_2/)

	delete(U250bpf_2)

	V250bpf_2 = fout_std->V250tdash_bpf*fout_std->V250tdash_bpf
	V250bpf_2!0 = fout_std->V250tdash_bpf!0
	V250bpf_2!1 = fout_std->V250tdash_bpf!1
	V250bpf_2!2 = fout_std->V250tdash_bpf!2
	print("calc V^2 250")
	
	fout_std->V250tdash_bpf_2 = (/V250bpf_2/)

	delete(V250bpf_2)

	print("calculated all bpf eddy winds squared")

; Calc EKEs

	EKE850bpf = 0.5 * fout_std->U850tdash_bpf_2 + fout_std->V850tdash_bpf_2
	print("calc U^2 + V^2 850")

	EKE850bpf!0 = fout_std->U850tdash_bpf_2!0
	EKE850bpf!1 = fout_std->U850tdash_bpf_2!1
	EKE850bpf!2 = fout_std->U850tdash_bpf_2!2

	fout_std ->EKE850tdash_bpf = (/EKE850bpf/)
	delete(EKE850bpf)

	EKE250bpf = 0.5 * fout_std->U250tdash_bpf_2 + fout_std->V250tdash_bpf_2
	print("calc U^2 + V^2 250")
	
	EKE250bpf!0 = fout_std->U250tdash_bpf_2!0
	EKE250bpf!1 = fout_std->U250tdash_bpf_2!1
	EKE250bpf!2 = fout_std->U250tdash_bpf_2!2
	
	fout_std ->EKE250tdash_bpf = (/EKE250bpf/)
	delete(EKE250bpf)
	print("printed it")

        fout_std ->VTH250tdash_bpf = (/VTH250bpf/)
        delete(VTH250bpf)
end do

end
