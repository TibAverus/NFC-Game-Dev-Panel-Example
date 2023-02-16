/// @param x
/// @param y
/// @param inputSystem
/// @param outputSystem
/// @param [camera]

//Precache the app surface draw parameters
__input_transform_coordinate(0, 0, 2, 2, undefined);

function __input_transform_coordinate(_x, _y, _inputSystem, _outputSystem, _camera = undefined)
{
    static _result = {
        x: 0,
        y: 0,
    };
    
    //Build out lots of cached values
    //We use these to detect changes that might trigger a recalculation of application_get_position()
    //Doing all this work is faster than calling application_get_position() all the time
    static _windowW      = undefined;
    static _windowH      = undefined;
    static _appSurfW     = undefined;
    static _appSurfH     = undefined;
    static _appSurfDrawL = undefined;
    static _appSurfDrawT = undefined;
    static _appSurfDrawW = undefined;
    static _appSurfDrawH = undefined;
    static _recacheTime  = -infinity;
    
    if (_inputSystem != _outputSystem) //Only do MATHS if the output system is different
    {
        //Only update the cached app surface draw parameters if we're going to need them
        if ((_inputSystem == 2) || (_outputSystem == 2))
        {
            //Detect changes in application surface size
            if ((_appSurfW != surface_get_width(application_surface))
            ||  (_appSurfH != surface_get_height(application_surface)))
            {
                _appSurfW = surface_get_width(application_surface);
                _appSurfH = surface_get_height(application_surface);
            
                //Recache application surface position immediately in this situation
                _recacheTime = -infinity;
            }
            
            if (current_time > _recacheTime)
            {
                _recacheTime = infinity;
                
                var _array = application_get_position();
                _appSurfDrawL = _array[0];
                _appSurfDrawT = _array[1];
                _appSurfDrawW = _array[2] - _appSurfDrawL;
                _appSurfDrawH = _array[3] - _appSurfDrawT;
            }
            
            //Detect changes in window size
            if ((_windowW != window_get_width())
            ||  (_windowH != window_get_height()))
            {
                _windowW = window_get_width();
                _windowH = window_get_height();
                
                //Recache application surface position after 200ms to give GM time to do whatever it does
                _recacheTime = current_time + 200;
            }
        }
        
        if (_inputSystem == 0) //Input coordinate system is room-space
        {
            //Grab a camera. Multiple levels of fallback here to cope with different setups
            _camera = _camera ?? camera_get_active();
            if (_camera < 0) _camera = view_camera[0];
            
            if (camera_get_view_angle(_camera) == 0) //Skip expensive rotation step if we can
            {
                //Reduce x/y to normalised values in the viewport
                _x = (_x - camera_get_view_x(_camera)) / camera_get_view_width( _camera);
                _y = (_y - camera_get_view_y(_camera)) / camera_get_view_height(_camera);
            }
            else
            {
                //Perform a rotation, eventually ending up with normalised values as above
                var _viewW  = camera_get_view_width( _camera);
                var _viewH  = camera_get_view_height(_camera);
                var _viewCX = camera_get_view_x(_camera) + _viewW/2;
                var _viewCY = camera_get_view_y(_camera) + _viewH/2;
                
                var _angle = camera_get_view_angle(_camera);
                var _sin = dsin(-_angle);
                var _cos = dcos(-_angle);
                
                var _x0 = _x - _viewCX;
                var _y0 = _y - _viewCY;
                _x = ((_x0*_cos - _y0*_sin) + _viewCX) / _viewW;
                _y = ((_x0*_sin + _y0*_cos) + _viewCY) / _viewH;
            }
            
            if (_outputSystem == 1)
            {
                //If we're outputting to GUI-space then simply multiply up by the GUI size
                _x *= display_get_gui_width();
                _y *= display_get_gui_height();
            }
            else if (_outputSystem == 2)
            {
                //If we're outputting to device-space then perform a transform using the cached app surface draw parameters
                _x = _appSurfDrawW*_x + _appSurfDrawL;
                _y = _appSurfDrawH*_y + _appSurfDrawT;
            }
            else
            {
                __input_error("Unhandled output coordinate system (", _outputSystem, ")");
            }
        }
        else if (_inputSystem == 1) //Input coordinate system is GUI-space
        {
            //Reduce x/y to normalised values in GUI-space
            _x /= display_get_gui_width();
            _y /= display_get_gui_height();
            
            if (_outputSystem == 0)
            {
                //Grab a camera. Multiple levels of fallback here to cope with different setups
                _camera = _camera ?? camera_get_active();
                if (_camera < 0) _camera = view_camera[0];
                
                if (camera_get_view_angle(_camera) == 0) //Skip expensive rotation step if we can
                {
                    //Expand room-space x/y from normalised values in the viewport
                    _x = camera_get_view_width( _camera)*_x + camera_get_view_x(_camera);
                    _y = camera_get_view_height(_camera)*_y + camera_get_view_y(_camera);
                }
                else
                {
                    //Perform a rotation, eventually ending up with room-space coordinates as above
                    var _viewW  = camera_get_view_width( _camera);
                    var _viewH  = camera_get_view_height(_camera);
                    var _viewCX = camera_get_view_x(_camera) + _viewW/2;
                    var _viewCY = camera_get_view_y(_camera) + _viewH/2;
                    
                    var _angle = camera_get_view_angle(_camera);
                    var _sin = dsin(_angle);
                    var _cos = dcos(_angle);
                    
                    var _x0 = _x*_viewW - _viewCX;
                    var _y0 = _y*_viewH - _viewCY;
                    _x = (_x0*_cos - _y0*_sin) + _viewCX;
                    _y = (_x0*_sin + _y0*_cos) + _viewCY;
                }
            }
            else if (_outputSystem == 2)
            {
                //If we're outputting to device-space then perform a transform using the cached app surface draw parameters
                _x = _appSurfDrawW*_x + _appSurfDrawL;
                _y = _appSurfDrawH*_y + _appSurfDrawT;
            }
            else
            {
                __input_error("Unhandled output coordinate system (", _outputSystem, ")");
            }
        }
        else if (_inputSystem == 2) //Input coordinate system is device-space
        {
            _x = (_x - _appSurfDrawL) / _appSurfDrawW;
            _y = (_y - _appSurfDrawT) / _appSurfDrawH;
            
            if (_outputSystem == 1)
            {
                //Reduce x/y to normalised values in GUI-space
                _x *= display_get_gui_width();
                _y *= display_get_gui_height();
            }
            else if (_outputSystem == 0)
            {
                //Grab a camera. Multiple levels of fallback here to cope with different setups
                _camera = _camera ?? camera_get_active();
                if (_camera < 0) _camera = view_camera[0];
                
                if (camera_get_view_angle(_camera) == 0) //Skip expensive rotation step if we can
                {
                    //Expand room-space x/y from normalised values in the viewport
                    _x = camera_get_view_width( _camera)*_x + camera_get_view_x(_camera);
                    _y = camera_get_view_height(_camera)*_y + camera_get_view_y(_camera);
                }
                else
                {
                    //Perform a rotation, eventually ending up with room-space coordinates as above
                    var _viewW  = camera_get_view_width( _camera);
                    var _viewH  = camera_get_view_height(_camera);
                    var _viewCX = camera_get_view_x(_camera) + _viewW/2;
                    var _viewCY = camera_get_view_y(_camera) + _viewH/2;
                    
                    var _angle = camera_get_view_angle(_camera);
                    var _sin = dsin(_angle);
                    var _cos = dcos(_angle);
                    
                    var _x0 = _x*_viewW - _viewCX;
                    var _y0 = _y*_viewH - _viewCY;
                    _x = (_x0*_cos - _y0*_sin) + _viewCX;
                    _y = (_x0*_sin + _y0*_cos) + _viewCY;
                }
            }
            else
            {
                __input_error("Unhandled output coordinate system (", _outputSystem, ")");
            }
        }
        else
        {
            __input_error("Unhandled input coordinate system (", _inputSystem, ")");
        }
    }
    
    //Set values and return!
    _result.x = _x;
    _result.y = _y;
    return _result;
}