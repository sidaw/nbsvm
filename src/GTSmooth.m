function f_gt = GTSmooth(f)
  f_gt  = zeros(size(f));
  ff = histc(f, 1:max(f));
  adjfac = 1:(max(ff));
  for c = 1:5
    N_kp1 = ff(c+1);
    N_k = ff(c);
    
    adj = N_kp1 * (c + 1) /  N_k;
    adjfac(c) = adj;
  end
  adj0 = ff(1);
  nz = sum(f == 0);
  for i=1:length(f)
    if f(i) ~= 0
      f_gt(i) = adjfac(f(i));
    else
      f_gt(i) = adj0 ./ nz;
    end
  end



