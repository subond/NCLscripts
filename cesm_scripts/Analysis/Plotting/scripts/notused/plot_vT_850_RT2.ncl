load "$NCARG_ROOT/lib/ncarg/nclex/gsun/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

nyears = 40

secdays = 86400.0

Experiments = (/"CESMtopof19","CESMnoRT2f19","CESMnoRf19","CESMnoT2f19"/);,"CESMnotopof19"
print(Experiments)

nexps = dimsizes(Experiments)

diro = "/home/disk/rachel/CESM_outfiles/" + Experiments(0) + "/atm/hist/"
filo = "EKE_EV_bpf_DJF_" + tostring(nyears) + "_" + Experiments(0) + ".cam2.h1.nc"
cdf_file = addfile(diro + filo, "r")

ndims = dimsizes(cdf_file->vth_850bpf)

VTH850 = new((/nexps,ndims(1),ndims(2)/),typeof(cdf_file->vth_850bpf))
PHIS = new((/nexps,ndims(1),ndims(2)/),typeof(cdf_file->vth_850bpf))

VTH850(0,:,:) = dim_avg_n(cdf_file->vth_850bpf(:,:,:),0)

lats = cdf_file->lat
lons = cdf_file->lon

delete(cdf_file)


diro = "/home/disk/rachel/CESM_outfiles/" + Experiments(0) + "/atm/hist/"
filo = "DJF" + tostring(nyears) + "_mean_" + Experiments(0) + ".cam2.h0.nc"
cdf_file = addfile(diro + filo, "r")

PHIS(0,:,:) = cdf_file->PHIS(0,:,:) / 9.8
delete(cdf_file)


do iexp = 1,nexps-1

	diro = "/home/disk/rachel/CESM_outfiles/" + Experiments(iexp) + "/atm/hist/"
	filo = "EKE_EV_bpf_DJF_" + tostring(nyears) + "_" + Experiments(iexp) + ".cam2.h1.nc"

	cdf_file = addfile(diro + filo, "r")

	VTH850(iexp,:,:) = dim_avg_n(cdf_file->vth_850bpf(:,:,:),0)
	
	delete(cdf_file)

	diro = "/home/disk/rachel/CESM_outfiles/" + Experiments(iexp) + "/atm/hist/"
	filo = "DJF" + tostring(nyears) + "_mean_" + Experiments(iexp) + ".cam2.h0.nc"
	cdf_file = addfile(diro + filo, "r")
	PHIS(iexp,:,:) = cdf_file->PHIS(0,:,:) / 9.8
	delete(cdf_file)

end do

toplot850 = new((/5,ndims(1),ndims(2)/),typeof(VTH850))
toplot850(0,:,:) = VTH850(0,:,:)
toplot850(1,:,:) =  VTH850(0,:,:) - VTH850(1,:,:)
toplot850(2,:,:) =  VTH850(0,:,:) - VTH850(2,:,:)
toplot850(3,:,:) =  VTH850(0,:,:) - VTH850(3,:,:)
toplot850(4,:,:) =  toplot850(1,:,:) - toplot850(2,:,:) - toplot850(3,:,:)


toplot3 = new((/5,ndims(1),ndims(2)/),typeof(PHIS))
toplot3(0,:,:) = PHIS(0,:,:)
toplot3(1,:,:) =  PHIS(0,:,:) - PHIS(1,:,:)
toplot3(2,:,:) =  PHIS(0,:,:) - PHIS(2,:,:)
toplot3(3,:,:) =  PHIS(0,:,:) - PHIS(3,:,:)
toplot3(4,:,:) =  toplot3(1,:,:) - toplot3(2,:,:) - toplot3(3,:,:)

titles = new((/5/),typeof(Experiments))
titles(0) = Experiments(0)
titles(1) =  "(topo - noRT2)"
titles(2) =  "(topo - noR)" 
titles(3) =  "(topo - noT2)" 
titles(4) =  titles(1) + "-" + titles(2) + "-" + titles(3)

toplot850!1 = "lat"
toplot850!2 = "lon"

toplot850&lat = lats
toplot850&lon = lons

toplot850&lat@units="degree_north"
toplot850&lon@units="degree_east"

copy_VarCoords(toplot850,toplot3)


; plot
; plot one = 850mb

  wks   = gsn_open_wks ("eps","Figures/VTHbpf_850mb_40yrs_RT2")                  ; open workstation

  gsn_define_colormap(wks,"BlAqGrYeOrRe")         ; choose colormap
  plot = new(5,graphic)                          ; create a plot array

  res                      = True                 ; plot mods desired
   res@gsnDraw  = False                          ; don't draw
  res@gsnFrame = False                          ; don't advance frame
  res@cnFillOn             = True                 ; turn on color fill
  res@cnLinesOn            = False                ; turn off contour lines
  res@gsnSpreadColors      = True                 ; use full colormap
  res@gsnSpreadColorStart  = 10                   ; start at color 10
  res@gsnSpreadColorEnd    = 96                   ; end at color 96
  res@gsnAddCyclic         = True                 ; add cyclic point
  res@gsnCenterString         = "bpf VTH at 850mb,mKs:S:-1:N:, " + titles(0)  
  res@mpMinLatF = 0.0
  res@mpMaxLatF = 90.0

  res@lbOrientation   = "Vertical"                ; vertical label bar

  res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
  res@cnMinLevelValF  = 0.0			; set the minimum contour level
  res@cnMaxLevelValF  = 16.0			; set the maximum contour level
  res@cnLevelSpacingF       = 2.0      ; contour spacing

  plot(0) = gsn_csm_contour_map_ce(wks,toplot850(0,:,:),res) ;
  res@gsnCenterString         = titles(1)  


  res@cnMinLevelValF  = -2.0			; set the minimum contour level
  res@cnMaxLevelValF  = 2.0			; set the maximum contour level
  res@cnLevelSpacingF       = 0.4      ; contour spacing

  plot(1) = gsn_csm_contour_map_ce(wks,toplot850(1,:,:),res) ;

   res@gsnCenterString         = titles(2)  

  plot(2) = gsn_csm_contour_map_ce(wks,toplot850(2,:,:),res) ;

   res@gsnCenterString         = titles(3)  
  plot(3) = gsn_csm_contour_map_ce(wks,toplot850(3,:,:),res) ;

   res@gsnCenterString         = titles(4)  
  res@cnMinLevelValF  = -1.0			; set the minimum contour level
  res@cnMaxLevelValF  = 1.0			; set the maximum contour level
  res@cnLevelSpacingF       = 0.2      ; contour spacing

  plot(4) = gsn_csm_contour_map_ce(wks,toplot850(4,:,:),res) ;

  resOv = True
  resOv@gsnDraw = False                        ; do not draw the plot
  resOv@gsnFrame = False                       ; do not advance the frame
  resOv@cnLevelSelectionMode = "ExplicitLevels" ; use explicit levels
  resOv@cnLevels = (/1000.0,2000.0/)              ; set the contour levels
  resOv@gsnContourPosLineDashPattern = 1 	; sets negative contours to dash pattern 1
  resOv@cnLineLabelsOn       = False
  resOv@cnConstFLabelOn = False

do pp = 0,4
	plot_ov = gsn_csm_contour(wks,toplot3(pp,:,:),resOv)
	overlay(plot(pp),plot_ov)
end do

  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
  resP@gsnPanelBottom   = 0.05                   ; add space at bottom
  resP@gsnPaperOrientation = "landscape"          

      resP@gsnDraw = False                           ; draw later, in maximize mode
      panelid1 = gsn_panel_return(wks,plot,(/5,1/),resP) 

  gsn_panel(wks,plot,(/5,1/),resP)               ; now draw as one plot

      mres = True
      maximize_output(wks,mres)


end