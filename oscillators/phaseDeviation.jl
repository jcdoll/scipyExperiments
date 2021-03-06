# Simulate the amplitude and phase variation of an oscillator
# excited by thermal noise as a function of steady-state phase.
#
# Random fluctuations are applied to the in-phase (real) and
# out-of-phase (imag) components of the resonator amplitude
# and the resulting magnitude and phase are calculated.
module dev

using Winston

function angle_sim(numTrials, magReal, std_error, phaseRange)
  magImag = tand(phaseRange)*magReal;

  num_angles = length(phaseRange);
  meanMag = zeros(num_angles);
  stdMag = zeros(num_angles);
  meanAngle = zeros(num_angles);
  stdAngle = zeros(num_angles);

  for ii = 1:length(phaseRange)
    magRealNoisy = magReal + std_error*randn(numTrials);
    magImagNoisy = magImag[ii] + std_error*randn(numTrials);
    angleNoisy = atand(magImagNoisy./magRealNoisy);

    meanMag[ii] = mean(magRealNoisy);
    stdMag[ii] = std(magRealNoisy);

    meanAngle[ii] = mean(angleNoisy);
    stdAngle[ii] = std(angleNoisy);
  end

  return meanMag, stdMag, meanAngle, stdAngle
end

function plot_results(meanMag, stdMag, meanAngle, stdAngle, plotTol=0.1)
  t = Table(2,2);

  p1 = FramedPlot("xlabel", "Phase (\\circ)", "ylabel", "Magnitude (\\mu)");
  add(p1, Curve(phaseRange, meanMag, "color", "black", "width", 2))
  setattr(p1, yrange=magReal*[1-plotTol 1+plotTol])
  setattr(p1, xrange=(0,90))
  t[1,1] = p1;

  p2 = FramedPlot("xlabel", "Phase (\\circ)", "ylabel", "Magnitude (\\sigma)");
  add(p2, Curve(phaseRange, stdMag, "color", "red"))
  setattr(p2, yrange=std_error*[1-plotTol 1+plotTol])
  setattr(p2, xrange=(0,90))
  t[1,2] = p2;

  p3 = FramedPlot("xlabel", "Phase (\\circ)", "ylabel", "Angle (\\mu)");
  add(p3, Curve(phaseRange, meanAngle, "color", "black"))
  setattr(p3, xrange=(0,90))
  setattr(p3, yrange=(0,90))
  t[2,1] = p3;

  p4 = FramedPlot("xlabel", "Phase (\\circ)", "ylabel", "Angle (\\sigma)");
  add(p4, Curve(phaseRange, stdAngle, "color", "red"))
  setattr(p4, xrange=(0,90))
  t[2,2] = p4;

  # file(t, "../images/phaseDeviationJulia.png", "width", 800, "height", 600)
end

const magReal = 1;
const numTrials = int(1e3);
const std_error = 0.1;
const num_angles = 91;
const angle_range = [0 90];
const phaseRange = linspace(angle_range[1], angle_range[2], num_angles);

tic();
(meanMag, stdMg, meanAngle, stdAngle) = angle_sim(numTrials, magReal, std_error, phaseRange)
toc();

tic();
plot_results(meanMag, stdMg, meanAngle, stdAngle)
toc();


end
