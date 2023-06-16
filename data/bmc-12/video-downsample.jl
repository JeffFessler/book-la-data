# video-downsample.jl

using ColorTypes: RGB, FixedPointNumbers
using ColorVectorSpace
using Downloads: download
#using InteractiveUtils: versioninfo
#using LaTeXStrings
#using LinearAlgebra: Diagonal, I, norm, svd, svdvals
#using LinearMapsAA: LinearMapAA, redim
#using MIRT: pogm_restart
using MIRTjim: jim, prompt
#using Plots: default, gui, plot, savefig
using Plots: savefig
import VideoIO
#default(); default(markerstrokecolor=:auto, label = "", markersize=6,
#legendfontsize = 8) # todo: increase

#=
## Load video data
=#

# Load raw data
if !@isdefined(z3)
    tmp = homedir() * "/111.mp4"
    if !isfile(tmp)
        url = "http://backgroundmodelschallenge.eu/data/synth1/111.mp4"
        @info "downloading 16MB from $url"
        tmp = download(url)
        @info "download complete"
    end

    z1 = VideoIO.load(tmp) # 1499 frames of size (480,640)

    z2 = @view z1[1:10:end] # 150 frames

    z3 = z2[51:end] # 100 "interesting" frames with moving cars
end;

z4 = stack(z3)

z5 = 0.5f0 * z4[1:2:end,:,:] + 0.5f0 * z4[2:2:end,:,:]
z5 = 0.5f0 * z5[:,1:2:end,:] + 0.5f0 * z5[:,2:2:end,:]

z6 = RGB{FixedPointNumbers.N0f8}.(z5) # 100 of size (240,320)


nf = size(z6,3)
p1 = jim(
 jim(z6[:,:,1]', title="Frame 001"),
 jim(z6[:,:,end]', title="Frame $nf"),
 ;
 size = (700, 300),
)

# savefig(p1, "first-last.png")

# VideoIO.save("111-240-320-100.mp4", eachslice(z6, dims=3)) # 100 frames of size (240,320)
