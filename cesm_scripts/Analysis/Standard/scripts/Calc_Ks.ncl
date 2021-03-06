load "$NCARG_ROOT/lib/ncarg/nclex/gsun/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; Code to calculate Rossby stationary wave number, following Hoskins and Ambrizzi 1993. 
; Rossby waves are refracted in latitude towards regions of higher Ks
; As dl/dt = cg dKs/dy
; Ks is defined as (Beta*/Uzm)^0.5
; Or on a Mercator coordinate:
; Ks = (2Omega - 1/a(1/cos(phi) d/dphi(1/cos(phi) d/dphi(cos(phi)U))))*cos2(phi)/a
begin

; Get experiment names

print("Calc Rossby Refractive Index")
Direc = getenv("NCL_ARG_1")
nexps = toint(getenv("NCL_ARG_2"))
Experiments = new(nexps,"string")

do ne = 0,nexps-1
        Experiments(ne) = getenv("NCL_ARG_" + tostring(3+ne))
end do

startyr = toint(getenv("NCL_startyr"))
endyr = toint(getenv("NCL_endyr"))

nyears = endyr-startyr+1

a = 6.37122e06	; radius of Earth
PI = 3.14159265358979

cp = 1.00464e3
Rd = 287.0
kappa = (Rd/cp)
omega =  7.2921e-5
g = 9.80616

dimsexps = dimsizes(Experiments)
nexps = dimsexps(0)

timespans = (/"Annual","DJF","JJA","MAM","SON"/)
;timespan = getenv("NCL_season")
dimtimes = dimsizes(timespans)
nts = dimtimes(0)

do ts = 0,nts - 1

    timespan = timespans(ts)
    dimsexps = dimsizes(Experiments)
    nexps = dimsexps(0)

    do exps = 0,nexps-1
        Experiment = Experiments(exps)
        Dir = (Direc + Experiment + "/atm/hist/")
        print(Experiment)

        filenamepl = Dir + timespan + tostring(startyr) + "_" + tostring(nyears) + "_mean_Xpl_" + Experiment + ".cam2.h0.nc"
        ; open file with seasonal averages
        cdf_filepl = addfile(filenamepl,"r")

        ; get pressure levels

        level = cdf_filepl->lev_p		; in hpa, or mb
        level!0="lev_p"
        levsizes = dimsizes(level)
        nlevels = filevardimsizes(cdf_filepl,"lev_p")
        nlat = filevardimsizes(cdf_filepl,"lat")
        nlon = filevardimsizes(cdf_filepl,"lon")

        lat = tofloat(cdf_filepl->lat)
        lat!0="lat"
        lon = tofloat(cdf_filepl->lon)
        lon!0="lon"

        U = cdf_filepl->U(:,:,:,:)

    ; Set up some constants
        phi = lat*PI/180.0      ; Get latitude in radians
        cphi = cos(phi)
        c2phi = cphi * cphi
        acphi = a * cos(phi)
        asphi = a * sin(phi)
        f = 2*omega*sin(phi)
        a2 = a*a
        f2 = f * f


    ; Calculate Ucos(phi)

        Ucphi = U * conform(U,cphi,2)
        copy_VarCoords(U,Ucphi)

    ; Calculate d/dphi (Ucphi)
        dUcphidphi = center_finite_diff_n(Ucphi(time|:,lev_p|:,lat|:,lon|:),phi,False,0,2)

    ; Calculate 1/cphi * dUcphi/dphi
        tempdUcphidphi = dUcphidphi / conform(dUcphidphi,cphi,2)
    ; Calculate meridional gradient of this

        d2Uetcdphi = center_finite_diff_n(tempdUcphidphi,phi,False,0,2)

    ; Calculate BetaM

        BetaM1 = 2.0 * omega * c2phi / a

        BetaM2 = d2Uetcdphi * conform(d2Uetcdphi,c2phi,2) / a2

        BetaM = conform(BetaM2,BetaM1,2) - BetaM2

    ; Calculate Ks = (a^2 cos(phi) * BetaM / U)^0.5

        Ks = sqrt(conform(BetaM,a2,-1) * conform(BetaM,cphi,2) * BetaM / U)

        Ks!0 = "time"
        Ks!1 = "lev_p"
        Ks!2 = "lat"
        Ks!3 = "lon"

        Ks@lev_p = level
        Ks@lat = lat
        Ks@lon = lon	


        copy_VarCoords(Ks,BetaM)


    ;----------------------------------------------------------------------
    ; Write out results to a new netcdf file
    ;-----------------------------------------------------------------------

            filo = "Ks_" + timespan + tostring(startyr) + "_" + tostring(nyears) + "_" + Experiment + ".cam2.h0.nc"
            system("/bin/rm -f " + Dir + filo)
            fout_std = addfile(Dir + filo, "c")

            setfileoption(fout_std,"DefineMode",True)

    ;set attributes of output file
            fAtt = True
            fAtt@creation_date = systemfunc("date")
            fileattdef(fout_std,fAtt)

    ;set dimensions of output file
            dimNames = (/"time","lat","lon","lev_p"/)
            dimSizes = (/1,nlat,nlon,nlevels/)
            dimUnlim = (/False,False,False,False/)
            filedimdef(fout_std,dimNames,dimSizes,dimUnlim)

            filevardef(fout_std,"lat",typeof(lat),getvardims(lat))
            filevardef(fout_std,"level",typeof(level),getvardims(level))
            filevardef(fout_std,"lon",typeof(lon),getvardims(lon))

            filevardef(fout_std,"Ks",typeof(Ks),getvardims(Ks))
            filevardef(fout_std,"BetaM",typeof(Ks),getvardims(Ks))

        filevardef(fout_std,"U",typeof(U),getvardims(U))
        fout_std->U = U
        fout_std->Ks = Ks
        fout_std->BetaM = BetaM
            fout_std->lat = lat
            fout_std->level = level
            fout_std->lon = lon

            print("printed it")


    end do
end do

end
