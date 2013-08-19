classdef agilentDMM < handle
    %AGILENTDMM This is an abstraction of the Agilent Signal Generator   
    %
    
    
    properties
        tcphandle = 0;
        hostaddress = 0;
        hostport = 5025;
        
        SRC_INTERNAL = 'IMMediate';
        SRC_EXTERNAL = 'EXTernal';
        SRC_BUS = 'BUS';
        MAX = 'MAX';
        MIN = 'MIN';
        AUTO = 'AUTO';
        VOLTRANGE_100mV = '100 mV'; 
        VOLTRANGE_1V = '1 V'; 
        VOLTRANGE_10V = '10 V'; 
        VOLTRANGE_100V = '100 V';
        VOLTRANGE_1000V = '1000 V';
        INPUTBUFSZ = 4096;
        
    end
    
    methods
        function obj = agilentDMM(varargin)
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
                                
            obj.tcphandle = tcpip( obj.hostaddress, obj.hostport,'InputBufferSize', obj.INPUTBUFSZ);
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
            obj.print('SYSTem:PRESet\n')
            obj.print('*RST\n')
        end
        
        function setCurrentDC(obj, limit, precision)
            obj.print(sprintf('CONF:CURR:DC %s, %s\n', limit, precision));
            
        end
		
        function setVoltageDC(obj, limit, precision)
            obj.print(sprintf('CONF:VOLT:DC %s, %s\n', limit, precision));
        end
		
        function setExtTrigger(obj)
            obj.print('TRIGger:SOURCE EXT\n');
        end
		
        function setTriggerCount(obj, count)
            obj.print(sprintf('TRIGger:COUNT %d', count));
        end
        
        function setSlowFilter(obj)
            obj.print('SENSe:VOLTage:AC:BANDwidth 3\n')
        end
        
        function setMediumFilter(obj)
            obj.print('SENSe:VOLTage:AC:BANDwidth 20\n')
        end
        
        function setFastFilter(obj)
            obj.print('SENSe:VOLTage:AC:BANDwidth 200\n')
        end
        
        function setFreqAperture(obj, time)
            obj.print(sprintf('SENSe:FREQuency:APERture %d\n',time))
        end
        
        function settrigger(obj,source)                    
            obj.print(sprintf('TRIGger:SOURce %s', source));
        end
        
        function setPeriodAperture(obj, time)
            obj.print(sprintf('SENSe:PERiod:APERture %.3f\n',time))
        end                                                        
        
        function init(obj)
            obj.print('INIT\n');            
        end
        
        function trigger(obj)
            obj.print('*TRG\n');            
        end
        
        function sampleCount(obj, count)
            obj.print(sprintf('SAMPle:COUNt %d\n',count))
        end

        function preTriggerSampleCount(obj, count)
            obj.print(sprintf('SAMPle:COUNt:PRETrigger %d\n',count));
        end
        
        function triggerDelay(obj, time)
            obj.print(sprintf('TRIGger:DELAy %.3f\n',time));
        end
        
        function measureAC(obj, range)
            obj.print(sprintf('CONFigure:VOLTage:AC %s\n', range));
        end
        

        
        function [data] = read(obj)
            data = '';
            obj.print('R?\n');
            pause(0.25);
            if get(obj.tcphandle,'BytesAvailable') > 0
                firstchar = char(fread(obj.tcphandle,1));
                if firstchar ~= '#'                    
                    return
                end                
                secondchar = fread(obj.tcphandle,1);
                sz_sz = str2double(char(secondchar));
                sz = fread(obj.tcphandle,sz_sz);
                sz = str2num(char(sz'));
                
                while sz > 0
                    bytes2read = get(obj.tcphandle,'BytesAvailable');
                    if sz > bytes2read                        
                        S1 = fscanf(obj.tcphandle,'%s',bytes2read);
                        sz = sz - bytes2read;
                        data = strcat(data,S1);
                    else
                        S1 = fscanf(obj.tcphandle,'%s',sz);
                        data = strcat(data,S1);
                        sz = 0;
                    end                  
                end    
                data = str2double(regexp(data,',','split'));
            end                        
        end
        
        function [data] = readN(obj,N)
            data = zeros(1,N);            
            n = 0;
            while n < N
                vals = obj.read();
                for val=vals
                    n=n+1;
                    data(n)=val;
                end
            end
        end
        
    end
    
end