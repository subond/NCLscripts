load "$NCARG_ROOT/lib/ncarg/nclex/gsun/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

nyears = 20

Experiments = (/"CESMSOMtopof19g16","CESMSOM2topof19g16","CESMSOM4topof19g16"/)


dimsexps = dimsizes(Experiments)
nexps = dimsexps(0)
print(nexps)

pnew           = (/  20, 50, 100,250 \
                     , 300,400,500,600,700,750,775,850,925,1000 /)

do exps = 0,nexps-1

Experiment = Experiments(exps)

print(Experiment)

filename = ("/home/disk/rachel/CESM_outfiles/" + Experiment + "/atm/hist/DJF" + tostring(nyears) + "_mean_" + Experiment + ".cam2.h0.nc")

print("reading file in...")
  cdf_file = addfile(filename,"r")
print("file read in")


lat = cdf_file->lat
lon = cdf_file->lon
P0mb = 0.01*cdf_file->P0
U = cdf_file->U
V = cdf_file->V
T = cdf_file->T
Z3 = cdf_file->Z3
Q = cdf_file->Q
Omega = cdf_file->OMEGA

hyam = cdf_file->hyam
hybm = cdf_file->hybm
PS = cdf_file->PS

dims1 = dimsizes(U)
dimslev = dimsizes(pnew)
print(dims1)


Tpres = vinth2p(T,hyam,hybm,pnew,PS,1,P0mb,1,True)
Upres = vinth2p(U,hyam,hybm,pnew,PS,1,P0mb,1,True) 
Vpres = vinth2p(V,hyam,hybm,pnew,PS,1,P0mb,1,True) 
Z3pres = vinth2p(Z3,hyam,hybm,pnew,PS,1,P0mb,1,True) 
Qpres = vinth2p(Q,hyam,hybm,pnew,PS,1,P0mb,1,True) 
Omegapres = vinth2p(Omega,hyam,hybm,pnew,PS,1,P0mb,1,True) 


;-----------------------------------------------------------------------
;Write variables to a new netcdf file, for stat fits in matlab
;-----------------------------------------------------------------------
diro = "/home/disk/rachel/CESM_outfiles/" + Experiment +"/atm/hist/"
filo = "DJF" + tostring(nyears) + "_mean_pl_" + Experiment + ".cam2.h0.nc"
system("/bin/rm -f " + diro + filo)
fout = addfile(diro + filo, "c")

setfileoption(fout,"DefineMode",True)

; set attributes of output file
fAtt = True
fAtt@creation_date = systemfunc("date")
fileattdef(fout,fAtt)

;set dimensions of output file
dimNames = (/"time","lev_p","lat","lon"/)
dimSizes = (/dims1(0),dimslev(0),dims1(2),dims1(3)/)
dimUnlim = (/True,False,False,False/)
filedimdef(fout,dimNames,dimSizes,dimUnlim)

filevardef(fout,"lat",typeof(lat),getvardims(lat))
filevardef(fout,"lon",typeof(lon),getvardims(lon))
filevardef(fout,"lev_p",typeof(pnew),(/"lev_p"/))

filevardef(fout,"U",typeof(Upres),getvardims(Upres))
filevardef(fout,"V",typeof(Vpres),getvardims(Vpres))
filevardef(fout,"T",typeof(Tpres),getvardims(Tpres))
filevardef(fout,"Z3",typeof(Z3pres),getvardims(Z3pres))
filevardef(fout,"Q",typeof(Qpres),getvardims(Qpres))
filevardef(fout,"OMEGA",typeof(Omegapres),getvardims(Omegapres))


fout ->lat    = (/lat/)
fout ->lon    = (/lon/)
fout ->lev_p    = (/pnew/)

fout ->U      = (/Upres/)
fout ->V      = (/Vpres/)
fout ->T      = (/Tpres/)
fout ->Z3      = (/Z3pres/)
fout ->Q      = (/Qpres/)
fout ->OMEGA      = (/Omegapres/)

delete(Experiment)
delete([/lat,lon,P0mb,U,V,T,Q,Z3,hyam,hybm,PS,Omega/])
delete(filename)
delete([/Tpres,Upres,Vpres,Qpres,Z3pres,Omegapres/])

end do

end