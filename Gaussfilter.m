function z_filted = Gaussfilter(r, sigma, z)

% 生成一维高斯滤波模板
GaussTemp = ones(1,r*2-1);
for i=1 : r*2-1
    GaussTemp(i) = exp(-(i-r)^2/(2*sigma^2))/(sigma*sqrt(2*pi));
end

% 高斯滤波
z_filted = z;
for i = r : length(z)-r+1
    z_filted(i) = z(i-r+1 : i+r-1)*GaussTemp';
end
