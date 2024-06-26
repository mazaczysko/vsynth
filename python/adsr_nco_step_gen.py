f_clk = 32000
N = 24

max_val = pow(2,N)

for i in range(0,128):
    t = pow((i+7)/127, 3)*8
    f=1/t
    step = round((f/f_clk)*max_val)
    f_act = (step/max_val)*f_clk
    #print("t=", t, "\tf=", f, "\tstep=", step, "\tf_act=", f_act, "\tf_err=", f_act - f)
    print(format(step, '05x'))