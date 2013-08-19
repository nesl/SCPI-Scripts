classdef agilentSigGen < handle
    %AGILENTSIGGEN This is an abstraction of the Agilent Signal Generator   
    %
    
    
    properties
        tcphandle = 0;
        hostaddress = 0;
        hostport = 5025; 
        INTERNAL = 'IMMediate'
        EXTERNAL = 'EXTernal'
        BUS = 'BUS'
    end
    
    methods
        function obj = agilentSigGen(varargin)
            import mbed.*
            optargin = size(varargin, 2);            
            if optargin >= 2
                obj.hostaddress = varargin{1};
                obj.hostport = varargin{2};
            else
                 error('NOHOST', 'Reuires TCPIP host and port');
            end
            
            if optargin >= 3
                DEBUG = varargin{3};
                if  DEBUG
                    echotcpip('on',obj.hostport);
                end
            end
                                
            obj.tcphandle = tcpip( obj.hostaddress, obj.hostport);
            fopen(obj.tcphandle);
            
        end
        
        function write(obj, msg)
            fwrite(obj.tcphandle, msg)
        end
        
        function print(obj,msg)
            fprintf(obj.tcphandle, msg);
        end
        
        function delete(obj)
            fclose(obj.tcphandle);
            delete(obj.tcphandle);            
        end
        
        function reset(obj)
            obj.print('*RST\n')
            obj.print('*CLS\n')
        end
                        
        function square(obj)
            obj.print('FUNCtion SQUare\n')            
        end
        
        function sine(obj)
            obj.print('FUNCtion SIN\n')
        end
        
        function voltage(obj, low, high)
            obj.print(sprintf('VOLTage:HIGH %.4f',high));
            obj.print(sprintf('VOLTage:LOW %.4f',low));                        
        end
        
        function hiz(obj)
            obj.print('OUTPut:LOAD INFinity\n')
        end
        
        function load(obj, ohms)
            obj.print(sprintf('OUTPut:LOAD %d\n', ohms));
        end
        
        function linSweep(obj,start,stop,time)
            obj.print(sprintf('FREQ:STAR %.3f\n', start));
            obj.print(sprintf('FREQ:STOP %.3f\n', stop));
            obj.print('SWEep:SPAC LIN');            
            obj.print(sprintf('SWE:TIME %.3f\n', time))
            obj.print('SWEep:STAT ON\n')                        
        end
                        
        function applysine(obj, freq, vpp, offset)
            obj.print(sprintf('APPLy:SIN %d, %.4f, %.3f', freq,vpp,offset))
        end
        
        function vpp(obj)
            obj.print('VOLTage:UNIT VPP\n');            
        end
        
        function vrms(obj)
            obj.print('VOLTage:UNIT VRMS\n');            
        end
        
        function dbm(obj)
            obj.print('VOLTage:UNIT DBM\n');            
        end
        
        function applypulse(obj, freq, dutycylce, offset)
            obj.print(sprintf('APPLy:PULSe %.2f, %.3, \n', freq, dutycylce, offset));                        
        end
        
        function on(obj)
            obj.print('OUTPut ON\n');
        end
       
        function off(obj)
            obj.print('OUTPut OFF\n');
        end
        
        function frequency(obj, freq)
            obj.print(sprintf('FREQuency %.4f\n', freq));
        end

        function settrigger(obj,source)                    
            obj.print(sprintf('TRIGger:SOURce %s', source));
        end
        
        function trigger(obj)
            obj.print('*TRG\n');
        end
        
    end
    
end